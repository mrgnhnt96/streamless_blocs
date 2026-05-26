part of bloc;

/// Event mapper used to invoke an [EventHandler] for each incoming event.
typedef EventMapper<Event, State> =
    FutureOr<void> Function(Event event, Emitter<State> emit);

/// Event transformer used to customize how events are processed.
typedef EventTransformer<Event, State> =
    FutureOr<void> Function(
      Event event,
      EventMapper<Event, State> mapper,
      Emitter<State> emit,
    );

/// An event handler is responsible for reacting to an incoming [Event]
/// and can emit zero or more states via the [Emitter].
typedef EventHandler<Event, State> =
    FutureOr<void> Function(Event event, Emitter<State> emit);
