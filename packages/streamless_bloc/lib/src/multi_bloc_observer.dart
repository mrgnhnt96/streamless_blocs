/*
 * Originally derived from the Bloc package:
 * https://github.com/felangel/bloc
 * Copyright (c) 2019-present Felix Angelov
 * Modified for Streamless Blocs.
 */

import 'package:streamless_bloc/src/bloc_base.dart';
import 'package:streamless_bloc/src/change.dart';
import 'package:streamless_bloc/src/transition.dart';
import 'package:streamless_bloc/src/bloc_observer.dart';

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
  void onCreate(BlocBase<dynamic> bloc) {
    for (final observer in observers) {
      observer.onCreate(bloc);
    }
  }

  @override
  void onEvent(BlocBase<dynamic> bloc, Object? event) {
    for (final observer in observers) {
      observer.onEvent(bloc, event);
    }
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    for (final observer in observers) {
      observer.onChange(bloc, change);
    }
  }

  @override
  void onTransition(
    BlocBase<dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    for (final observer in observers) {
      observer.onTransition(bloc, transition);
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    for (final observer in observers) {
      observer.onError(bloc, error, stackTrace);
    }
  }

  @override
  void onDone(
    BlocBase<dynamic> bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    for (final observer in observers) {
      observer.onDone(bloc, event, error, stackTrace);
    }
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    for (final observer in observers) {
      observer.onClose(bloc);
    }
  }
}
