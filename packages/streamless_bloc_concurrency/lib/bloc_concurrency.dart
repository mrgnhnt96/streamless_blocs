library streamless_bloc_concurrency;

import 'dart:async';

import 'package:streamless_bloc/streamless_bloc.dart';

/// Process events concurrently.
EventTransformer<Event, State> concurrent<Event, State>() {
  return (event, mapper, emit) async {
    await mapper(event, emit);
  };
}

/// Process events one at a time in arrival order.
EventTransformer<Event, State> sequential<Event, State>() {
  Future<void> pending = Future<void>.value();
  return (event, mapper, emit) {
    final completer = Completer<void>();
    pending = pending.catchError((_, __) {}).then((_) async {
      await mapper(event, emit);
    });
    pending.then(
      (_) {
        if (!completer.isCompleted) completer.complete();
      },
      onError: (Object error, StackTrace stackTrace) {
        if (!completer.isCompleted) {
          completer.completeError(error, stackTrace);
        }
      },
    );
    return completer.future;
  };
}

/// Ignore incoming events while a previous event is still processing.
EventTransformer<Event, State> droppable<Event, State>() {
  var isRunning = false;
  return (event, mapper, emit) async {
    if (isRunning) return;
    isRunning = true;
    try {
      await mapper(event, emit);
    } finally {
      isRunning = false;
    }
  };
}

/// Wait for a pause in events before processing the latest event.
EventTransformer<Event, State> debounce<Event, State>(Duration duration) {
  Timer? timer;
  Completer<void>? pendingCompleter;
  var version = 0;

  return (event, mapper, emit) {
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
  };
}

/// Keep only the latest event and ignore emits from previous active handlers.
EventTransformer<Event, State> restartable<Event, State>() {
  var version = 0;
  return (event, mapper, emit) async {
    final activeVersion = ++version;
    final guardedEmit = _RestartableEmitter<State>(
      emit,
      () => activeVersion != version,
    );
    await mapper(event, guardedEmit);
  };
}

class _RestartableEmitter<State> implements Emitter<State> {
  const _RestartableEmitter(this._delegate, this._isStale);

  final Emitter<State> _delegate;
  final bool Function() _isStale;

  @override
  bool get isDone => _delegate.isDone || _isStale();

  @override
  void call(State state) {
    if (!_isStale() && !_delegate.isDone) {
      _delegate(state);
    }
  }
}
