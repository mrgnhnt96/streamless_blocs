part of streamless_bloc;

abstract class BlocEventSink<Event> {
  /// Adds an [event] to the sink.
  void add(Event event);
}
