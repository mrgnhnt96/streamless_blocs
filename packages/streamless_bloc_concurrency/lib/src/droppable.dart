import 'package:streamless_bloc/bloc.dart';

/// Process only one event and ignore (drop) any new events
/// until the current event is done.
///
/// **Note**: dropped events never trigger the event handler.
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
