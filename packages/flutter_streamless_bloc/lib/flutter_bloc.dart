// dart format width=200

import 'package:flutter_streamless_bloc/src/multi_streamless_bloc_listener.dart';
import 'package:flutter_streamless_bloc/src/multi_streamless_bloc_provider.dart';
import 'package:streamless_bloc/streamless_bloc.dart';

import 'flutter_streamless_bloc.dart';

typedef BlocBuilder<B extends StreamlessBlocBase<S>, S> = StreamlessBlocBuilder<B, S>;
typedef BlocListener<B extends StreamlessBlocBase<S>, S> = StreamlessBlocListener<B, S>;
typedef BlocConsumer<B extends StreamlessBlocBase<S>, S> = StreamlessBlocConsumer<B, S>;
typedef BlocSelector<B extends StreamlessBlocBase<S>, S, T> = StreamlessBlocSelector<B, S, T>;
typedef BlocProvider<T extends StreamlessBlocBase<Object?>> = StreamlessBlocProvider<T>;
typedef MultiBlocListener = MultiStreamlessBlocListener;
typedef MultiBlocProvider = MultiStreamlessBlocProvider;
