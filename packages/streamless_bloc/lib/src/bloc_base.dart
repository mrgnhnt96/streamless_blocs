part of bloc;

/// {@template bloc_base}
/// An interface for the core functionality implemented by both [Bloc] and [Cubit].
/// {@endtemplate}
abstract class BlocBase<State> {
  /// {@macro bloc_base}
  BlocBase(this._state) {
    // ignore: invalid_use_of_protected_member
    Bloc.observer.onCreate(this);
  }

  final BlocObserver _blocObserver = Bloc.observer;

  State _state;
  bool _emitted = false;
  bool _disposed = false;

  /// The current [state].
  State get state => _state;

  bool get isClosed => _disposed;

  @visibleForTesting
  @protected
  void emit(State state) {
    try {
      if (isClosed) {
        throw StateError('Cannot emit new states after calling close');
      }
      if (state == _state && _emitted) return;
      onChange(Change(currentState: state, nextState: state));
      _state = state;
      _emitted = true;
      for (final listener in _stateListeners) {
        try {
          listener(state);
        } catch (e) {
          onError(e);
        }
      }
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      rethrow;
    }
  }

  final List<void Function(State)> _stateListeners = [];

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
      onError(error, stackTrace ?? StackTrace.current);

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
