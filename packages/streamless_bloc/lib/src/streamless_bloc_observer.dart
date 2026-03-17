part of streamless_bloc;

/// {@template bloc_observer}
/// An interface for observing the behavior of [StreamlessBloc] instances.
/// {@endtemplate}
abstract class StreamlessBlocObserver {
  /// {@macro bloc_observer}
  const StreamlessBlocObserver();

  /// Called whenever a [StreamlessBloc] is instantiated.
  @protected
  @mustCallSuper
  void onCreate(StreamlessBlocBase bloc) {}

  /// Called whenever an [event] is `added` to any [bloc] with the given [bloc]
  /// and [event].
  @protected
  @mustCallSuper
  void onEvent(StreamlessBloc bloc, Object? event) {}

  /// Called whenever a [Change] occurs in any [bloc]
  /// A [change] occurs when a new state is emitted.
  @protected
  @mustCallSuper
  void onChange(StreamlessBlocBase bloc, Change change) {}

  /// Called whenever a transition occurs in any [bloc] with the given [bloc]
  /// and [transition].
  @protected
  @mustCallSuper
  void onTransition(StreamlessBloc bloc, Transition transition) {}

  /// Called whenever an [error] is thrown in any [StreamlessBloc] or [StreamlessCubit].
  @protected
  @mustCallSuper
  void onError(StreamlessBlocBase bloc, Object error, StackTrace stackTrace) {}

  /// Called whenever an [event] handler for a specific [bloc] has completed.
  @protected
  @mustCallSuper
  void onDone(
    StreamlessBloc bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {}

  /// Called whenever a [StreamlessBloc] is closed.
  @protected
  @mustCallSuper
  void onClose(StreamlessBlocBase bloc) {}
}
