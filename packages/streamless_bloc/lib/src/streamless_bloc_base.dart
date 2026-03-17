part of streamless_bloc;

/// {@template bloc_base}
/// An interface for the core functionality implemented by both [StreamlessBloc] and [StreamlessCubit].
/// {@endtemplate}
abstract class StreamlessBlocBase<State> {
  /// {@macro bloc_base}
  StreamlessBlocBase(this._state) {
    // ignore: invalid_use_of_protected_member
    StreamlessBloc.observer.onCreate(this);
    _emit(_state);
  }

  final StreamlessBlocObserver _blocObserver = StreamlessBloc.observer;

  State _state;
  bool _emitted = false;
  bool _disposed = false;

  /// The current [state].
  State get state => _state;

  final List<void Function(State)> _stateListeners = [];

  void _emit(State newState) {
    if (_disposed) {
      throw StateError('Cannot emit new states after calling close');
    }

    if (newState == _state && _emitted) return;

    onChange(Change(currentState: this.state, nextState: state));
    _state = newState;
    _emitted = true;

    for (final listener in _stateListeners) {
      try {
        listener(newState);
      } catch (_) {}
    }
  }

  bool get isClosed => _disposed;

  @protected
  @mustCallSuper
  void onChange(Change<State> change) {
    // ignore: invalid_use_of_protected_member
    _blocObserver.onChange(this, change);
  }

  @protected
  @mustCallSuper
  void onError(Object error, [StackTrace? stackTrace]) {
    // ignore: invalid_use_of_protected_member
    _blocObserver.onError(this, error, stackTrace ?? StackTrace.current);
  }

  void addError(Object error, [StackTrace? stackTrace]) =>
      onError(error, stackTrace);

  @mustCallSuper
  Future<void> close() => dispose();

  @mustCallSuper
  Future<void> dispose() async {
    // ignore: invalid_use_of_protected_member
    _blocObserver.onClose(this);
    _disposed = true;
    _stateListeners.clear();
  }

  void addListener(void Function(State) listener) {
    _stateListeners.add(listener);
  }

  void removeListener(void Function(State) listener) {
    _stateListeners.remove(listener);
  }
}
