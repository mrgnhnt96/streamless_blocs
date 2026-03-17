// dart format width=250

import 'package:streamless_bloc/streamless_bloc.dart';

import 'flutter_streamless_bloc.dart' as fsb;

export 'package:provider/provider.dart' show ProviderNotFoundException, ReadContext, SelectContext, WatchContext;
export 'package:streamless_bloc/streamless_bloc.dart';

typedef BlocBuilder<B extends StreamlessBlocBase<S>, S> = fsb.StreamlessBlocBuilder<B, S>;
typedef BlocListener<B extends StreamlessBlocBase<S>, S> = fsb.StreamlessBlocListener<B, S>;
typedef BlocConsumer<B extends StreamlessBlocBase<S>, S> = fsb.StreamlessBlocConsumer<B, S>;
typedef BlocSelector<B extends StreamlessBlocBase<S>, S, T> = fsb.StreamlessBlocSelector<B, S, T>;
typedef BlocProvider<T extends StreamlessBlocBase<Object?>> = fsb.StreamlessBlocProvider<T>;
typedef MultiBlocListener = fsb.MultiStreamlessBlocListener;
typedef MultiBlocProvider = fsb.MultiStreamlessBlocProvider;
