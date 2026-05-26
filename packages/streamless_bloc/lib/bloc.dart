/// A predictable state management library for [Dart](https://dart.dev).
///
/// Replicates the bloc interface exactly but without using streams internally.
library bloc;

import 'dart:async';

import 'package:meta/meta.dart';

part 'src/__default_bloc_observer.dart';
part 'src/__handler.dart';
part 'src/bloc_event_sink.dart';
part 'src/change.dart';
part 'src/emitter.dart';
part 'src/event_handler.dart';
part 'src/multi_bloc_observer.dart';
part 'src/bloc.dart';
part 'src/bloc_base.dart';
part 'src/bloc_observer.dart';
part 'src/cubit.dart';
part 'src/transition.dart';
