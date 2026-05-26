part of bloc;

/// {@template multi_bloc_observer}
/// A [BlocObserver] which supports registering multiple [BlocObserver]
/// instances.
/// {@endtemplate}
class MultiBlocObserver implements BlocObserver {
  /// {@macro multi_bloc_observer}
  const MultiBlocObserver({required this.observers});

  /// The list of [BlocObserver] instances that will be registered.
  final List<BlocObserver> observers;

  @override
  void onCreate(BlocBase bloc) {
    for (final observer in observers) {
      observer.onCreate(bloc);
    }
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    for (final observer in observers) {
      observer.onEvent(bloc, event);
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    for (final observer in observers) {
      observer.onChange(bloc, change);
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    for (final observer in observers) {
      observer.onTransition(bloc, transition);
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    for (final observer in observers) {
      observer.onError(bloc, error, stackTrace);
    }
  }

  @override
  void onDone(
    Bloc bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    for (final observer in observers) {
      observer.onDone(bloc, event, error, stackTrace);
    }
  }

  @override
  void onClose(BlocBase bloc) {
    for (final observer in observers) {
      observer.onClose(bloc);
    }
  }
}
