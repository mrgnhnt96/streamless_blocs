/*
 * Originally derived from the Bloc package:
 * https://github.com/felangel/bloc
 * Copyright (c) 2019-present Felix Angelov
 * Modified for Streamless Bloc.
 */

import 'package:streamless_bloc/bloc.dart';
import 'package:streamless_bloc_concurrency/src/restartable_emitter.dart';

/// Process only one event by cancelling any pending events and
/// processing the new event immediately.
///
/// Avoid using [restartable] if you expect an event to have
/// immediate results -- it should only be used with asynchronous APIs.
///
/// **Note**: there is no event handler overlap and any currently running tasks
/// will be aborted if a new event is added before a prior one completes.
EventTransformer<Event, State> restartable<Event, State>() {
  var version = 0;
  return (event, mapper, emit) async {
    final activeVersion = ++version;
    final guardedEmit = RestartableEmitter<State>(
      emit,
      () => activeVersion != version,
    );
    await mapper(event, guardedEmit);
  };
}
