part of streamless_bloc;

/// {@template bloc}
/// Takes events as input and transforms them into states as output.
/// Processes events via a queue (no streams).
/// {@endtemplate}
abstract class StreamlessBloc<Event, State> extends StreamlessBlocBase<State>
    implements BlocEventSink<Event> {
  /// {@macro bloc}
  StreamlessBloc(super.initialState);

  /// The current [StreamlessBlocObserver] instance.
  static StreamlessBlocObserver observer = const _DefaultBlocObserver();

  final List<_Handler<Event, State>> _handlers = [];
  final List<Event> _eventQueue = [];
  final List<_Emitter<State>> _emitters = [];
  bool _isProcessing = false;

  @override
  void add(Event event) {
    final handlerExists = _handlers.any((h) => h.isType(event));
    if (!handlerExists) {
      throw StateError(
        'add(${event.runtimeType}) was called without a registered event '
        'handler.\nMake sure to register a handler via '
        'on<${event.runtimeType}>((event, emit) {...})',
      );
    }
    if (isClosed) {
      throw StateError('Cannot add new events after calling close');
    }

    try {
      onEvent(event);
      _eventQueue.add(event);
      unawaited(_processEvents());
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      rethrow;
    }
  }

  @protected
  @mustCallSuper
  void onEvent(Event event) {
    // ignore: invalid_use_of_protected_member
    _blocObserver.onEvent(this, event);
  }

  /// Register event handler for an event of type `E`.
  void on<E extends Event>(EventHandler<E, State> handler) {
    final handlerExists = _handlers.any((h) => h.type == E);
    if (handlerExists) {
      throw StateError(
        'on<$E> was called multiple times. '
        'There should only be a single event handler per event type.',
      );
    }

    _handlers.add(
      _Handler<E, State>(isType: (e) => e is E, type: E, handler: handler),
    );
  }

  Future<void> _processEvents() async {
    if (_isProcessing || _eventQueue.isEmpty || isClosed) return;
    _isProcessing = true;
    try {
      while (_eventQueue.isNotEmpty && !isClosed) {
        final event = _eventQueue.removeAt(0);
        _Handler<dynamic, State>? handler;
        for (final h in _handlers) {
          if (h.isType(event)) {
            handler = h;
            break;
          }
        }
        if (handler == null) continue;

        final (emitter, complete) = createEmitter<State>((state) {
          if (isClosed) return;

          onTransition(
            Transition<Event, State>(
              currentState: this.state,
              event: event,
              nextState: state,
            ),
          );

          _emit(state);
        });

        _emitters.add(emitter);
        try {
          await handler.handler(event, emitter);
          onDone(event);
        } catch (error, stackTrace) {
          onError(error, stackTrace);
          onDone(event, error, stackTrace);
          rethrow;
        } finally {
          complete();
          _emitters.remove(emitter);
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  @protected
  @mustCallSuper
  void onTransition(Transition<Event, State> transition) {
    // ignore: invalid_use_of_protected_member
    _blocObserver.onTransition(this, transition);
  }

  @protected
  @mustCallSuper
  void onDone(Event event, [Object? error, StackTrace? stackTrace]) {
    // ignore: invalid_use_of_protected_member
    _blocObserver.onDone(this, event, error, stackTrace);
  }

  @mustCallSuper
  @override
  Future<void> close() async {
    for (final emitter in List.from(_emitters)) {
      emitter.cancel();
    }
    await Future.wait<void>(_emitters.map((e) => e.future));
    await super.close();
  }
}
