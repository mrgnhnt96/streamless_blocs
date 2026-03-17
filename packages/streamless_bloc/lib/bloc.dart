// dart format width=250

import 'streamless_bloc.dart';

export 'streamless_bloc.dart' show EventHandler, Emitter, BlocEventSink, Change, Transition;

typedef Bloc<Event, State> = StreamlessBloc<Event, State>;
typedef Cubit<State> = StreamlessCubit<State>;
typedef BlocBase<State> = StreamlessBlocBase<State>;
typedef BlocObserver = StreamlessBlocObserver;
typedef MultiBlocObserver = MultiStreamlessBlocObserver;
