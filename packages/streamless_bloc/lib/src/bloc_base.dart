import 'package:meta/meta.dart';
import 'package:streamless_bloc/src/change.dart';
import 'package:streamless_bloc/src/transition.dart';

/// {@template bloc_observer}
/// An interface for observing the behavior of [Bloc] instances.
/// {@endtemplate}
abstract class BlocObserver {
  /// {@macro bloc_observer}
  const BlocObserver();

  /// Called whenever a [Bloc] is instantiated.
  @protected
  @mustCallSuper
  void onCreate(BlocBase<dynamic> bloc) {}

  /// Called whenever an [event] is `added` to any [bloc] with the given [bloc]
  /// and [event].
  @protected
  @mustCallSuper
  void onEvent(BlocBase<dynamic> bloc, Object? event) {}

  /// Called whenever a [Change] occurs in any [bloc]
  /// A [change] occurs when a new state is emitted.
  @protected
  @mustCallSuper
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {}

  /// Called whenever a transition occurs in any [bloc] with the given [bloc]
  /// and [transition].
  @protected
  @mustCallSuper
  void onTransition(
    BlocBase<dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {}

  /// Called whenever an [error] is thrown in any [Bloc] or [Cubit].
  @protected
  @mustCallSuper
  void onError(
    BlocBase<dynamic> bloc,
    Object error,
    StackTrace stackTrace,
  ) {}

  /// Called whenever an [event] handler for a specific [bloc] has completed.
  @protected
  @mustCallSuper
  void onDone(
    BlocBase<dynamic> bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {}

  /// Called whenever a [Bloc] is closed.
  @protected
  @mustCallSuper
  void onClose(BlocBase<dynamic> bloc) {}
}

class _DefaultBlocObserver extends BlocObserver {
  const _DefaultBlocObserver();
}

/// {@template bloc_base}
/// An interface for the core functionality implemented by both [Bloc] and [Cubit].
/// {@endtemplate}
abstract class BlocBase<State> {
  /// {@macro bloc_base}
  BlocBase(this._state) {
    // ignore: invalid_use_of_protected_member
    observer.onCreate(this);
  }

  /// The current [BlocObserver] instance.
  static BlocObserver observer = const _DefaultBlocObserver();

  final BlocObserver _blocObserver = observer;

  @protected
  BlocObserver get blocObserver => _blocObserver;

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
