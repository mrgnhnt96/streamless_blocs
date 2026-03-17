part of streamless_bloc;

/// {@template multi_bloc_observer}
/// A [StreamlessBlocObserver] which supports registering multiple [StreamlessBlocObserver]
/// instances.
/// {@endtemplate}
class MultiStreamlessBlocObserver implements StreamlessBlocObserver {
  /// {@macro multi_bloc_observer}
  const MultiStreamlessBlocObserver({required this.observers});

  /// The list of [StreamlessBlocObserver] instances that will be registered.
  final List<StreamlessBlocObserver> observers;

  @override
  void onCreate(StreamlessBlocBase bloc) {
    for (final observer in observers) {
      observer.onCreate(bloc);
    }
  }

  @override
  void onEvent(StreamlessBloc bloc, Object? event) {
    for (final observer in observers) {
      observer.onEvent(bloc, event);
    }
  }

  @override
  void onChange(StreamlessBlocBase bloc, Change change) {
    for (final observer in observers) {
      observer.onChange(bloc, change);
    }
  }

  @override
  void onTransition(StreamlessBloc bloc, Transition transition) {
    for (final observer in observers) {
      observer.onTransition(bloc, transition);
    }
  }

  @override
  void onError(StreamlessBlocBase bloc, Object error, StackTrace stackTrace) {
    for (final observer in observers) {
      observer.onError(bloc, error, stackTrace);
    }
  }

  @override
  void onDone(
    StreamlessBloc bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    for (final observer in observers) {
      observer.onDone(bloc, event, error, stackTrace);
    }
  }

  @override
  void onClose(StreamlessBlocBase bloc) {
    for (final observer in observers) {
      observer.onClose(bloc);
    }
  }
}
