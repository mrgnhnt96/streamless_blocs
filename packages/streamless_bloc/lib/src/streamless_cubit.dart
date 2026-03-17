part of streamless_bloc;

/// {@template cubit}
/// A [StreamlessCubit] is similar to [StreamlessBloc] but has no notion of events
/// and relies on methods to [emit] new states.
/// {@endtemplate}
abstract class StreamlessCubit<State> extends StreamlessBlocBase<State> {
  /// {@macro cubit}
  StreamlessCubit(super.initialState);
}
