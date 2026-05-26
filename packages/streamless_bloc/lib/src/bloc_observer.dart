part of bloc;

/// {@template bloc_observer}
/// An interface for observing the behavior of [Bloc] instances.
/// {@endtemplate}
abstract class BlocObserver {
  /// {@macro bloc_observer}
  const BlocObserver();

  /// Called whenever a [Bloc] is instantiated.
  @protected
  @mustCallSuper
  void onCreate(BlocBase bloc) {}

  /// Called whenever an [event] is `added` to any [bloc] with the given [bloc]
  /// and [event].
  @protected
  @mustCallSuper
  void onEvent(Bloc bloc, Object? event) {}

  /// Called whenever a [Change] occurs in any [bloc]
  /// A [change] occurs when a new state is emitted.
  @protected
  @mustCallSuper
  void onChange(BlocBase bloc, Change change) {}

  /// Called whenever a transition occurs in any [bloc] with the given [bloc]
  /// and [transition].
  @protected
  @mustCallSuper
  void onTransition(Bloc bloc, Transition transition) {}

  /// Called whenever an [error] is thrown in any [Bloc] or [Cubit].
  @protected
  @mustCallSuper
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {}

  /// Called whenever an [event] handler for a specific [bloc] has completed.
  @protected
  @mustCallSuper
  void onDone(
    Bloc bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {}

  /// Called whenever a [Bloc] is closed.
  @protected
  @mustCallSuper
  void onClose(BlocBase bloc) {}
}
