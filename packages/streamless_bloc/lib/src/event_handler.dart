part of streamless_bloc;

/// An event handler is responsible for reacting to an incoming [Event]
/// and can emit zero or more states via the [Emitter].
typedef EventHandler<Event, State> =
    FutureOr<void> Function(Event event, Emitter<State> emit);
