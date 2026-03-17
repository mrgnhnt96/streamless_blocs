/// A predictable state management library for [Dart](https://dart.dev).
///
/// Replicates the bloc interface exactly but without using streams internally.
library streamless_bloc;

import 'dart:async';

import 'package:meta/meta.dart';

part 'src/__default_bloc_observer.dart';
part 'src/__handler.dart';
part 'src/bloc_event_sink.dart';
part 'src/change.dart';
part 'src/emitter.dart';
part 'src/event_handler.dart';
part 'src/multi_streamless_bloc_observer.dart';
part 'src/streamless_bloc.dart';
part 'src/streamless_bloc_base.dart';
part 'src/streamless_bloc_observer.dart';
part 'src/streamless_cubit.dart';
part 'src/transition.dart';
