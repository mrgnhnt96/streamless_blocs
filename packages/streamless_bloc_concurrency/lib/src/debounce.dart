import 'dart:async';

import 'package:streamless_bloc/bloc.dart';

/// Wait for a pause in events before processing the latest event.
///
/// When [eager] is `true`, process the first event in a burst immediately,
/// then debounce subsequent incoming events.
EventTransformer<Event, State> debounce<Event, State>(
  Duration duration, {
  bool eager = false,
}) {
  Timer? timer;
  Completer<void>? pendingCompleter;
  Event? pendingEvent;
  var version = 0;
  EventMapper<Event, State>? activeMapper;
  Emitter<State>? activeEmit;
  var burstActive = false;

  return (event, mapper, emit) {
    activeMapper = mapper;
    activeEmit = emit;

    if (!eager) {
      timer?.cancel();

      if (pendingCompleter case final completer? when !completer.isCompleted) {
        // Previous pending event is dropped by a newer event.
        completer.complete();
      }

      final completer = Completer<void>();
      pendingCompleter = completer;
      final scheduledVersion = ++version;

      timer = Timer(duration, () async {
        try {
          if (scheduledVersion != version || emit.isDone) {
            if (!completer.isCompleted) completer.complete();
            return;
          }
          await mapper(event, emit);
          if (!completer.isCompleted) completer.complete();
        } catch (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        }
      });

      return completer.future;
    }

    void scheduleTrailingIfNeeded() {
      timer?.cancel();
      final scheduledVersion = ++version;
      timer = Timer(duration, () async {
        if (scheduledVersion != version) return;

        final latestEvent = pendingEvent;
        final latestCompleter = pendingCompleter;
        pendingEvent = null;
        pendingCompleter = null;

        // No queued event means the burst has gone quiet.
        if (latestEvent == null) {
          burstActive = false;
          timer = null;
          return;
        }

        try {
          if (!(activeEmit?.isDone ?? true)) {
            await activeMapper!(latestEvent, activeEmit!);
          }
          if (latestCompleter case final completer? when !completer.isCompleted) {
            completer.complete();
          }
        } catch (error, stackTrace) {
          if (latestCompleter case final completer? when !completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        }

        if (pendingEvent == null) {
          burstActive = false;
          timer = null;
          return;
        }

        // Continue debouncing while new events keep arriving.
        scheduleTrailingIfNeeded();
      });
    }

    if (!burstActive) {
      burstActive = true;
      scheduleTrailingIfNeeded();
      return mapper(event, emit);
    }

    if (pendingCompleter case final completer? when !completer.isCompleted) {
      // Previous pending event is dropped by a newer event.
      completer.complete();
    }

    final completer = Completer<void>();
    pendingCompleter = completer;
    pendingEvent = event;
    scheduleTrailingIfNeeded();
    return completer.future;
  };
}
