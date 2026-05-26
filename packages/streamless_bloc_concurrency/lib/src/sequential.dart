import 'dart:async';

import 'package:streamless_bloc/bloc.dart';

/// Process events one at a time by maintaining a queue of added events
/// and processing the events sequentially.
///
/// **Note**: there is no event handler overlap and every event is guaranteed
/// to be handled in the order it was received.
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
