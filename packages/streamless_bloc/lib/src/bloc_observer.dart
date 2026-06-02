/*
 * Originally derived from the Bloc package:
 * https://github.com/felangel/bloc
 * Copyright (c) 2019-present Felix Angelov
 * Modified for Streamless Bloc.
 */

import 'package:meta/meta.dart';
import 'package:streamless_bloc/src/bloc_base.dart';
import 'package:streamless_bloc/src/change.dart';
import 'package:streamless_bloc/src/transition.dart';

/// {@template bloc_observer}
/// An interface for observing the behavior of [Bloc] instances.
/// {@endtemplate}
abstract class BlocObserver {
  /// {@macro bloc_observer}
  const BlocObserver();

  /// Called whenever a [Bloc] is instantiated.
  @protected
  @mustCallSuper
  void onCreate(BlocBase<dynamic> bloc) {}

  /// Called whenever an [event] is `added` to any [bloc] with the given [bloc]
  /// and [event].
  @protected
  @mustCallSuper
  void onEvent(BlocBase<dynamic> bloc, Object? event) {}

  /// Called whenever a [Change] occurs in any [bloc]
  /// A [change] occurs when a new state is emitted.
  @protected
  @mustCallSuper
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {}

  /// Called whenever a transition occurs in any [bloc] with the given [bloc]
  /// and [transition].
  @protected
  @mustCallSuper
  void onTransition(
    BlocBase<dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {}

  /// Called whenever an [error] is thrown in any [Bloc] or [Cubit].
  @protected
  @mustCallSuper
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {}

  /// Called whenever an [event] handler for a specific [bloc] has completed.
  @protected
  @mustCallSuper
  void onDone(
    BlocBase<dynamic> bloc,
    Object? event, [
    Object? error,
    StackTrace? stackTrace,
  ]) {}

  /// Called whenever a [Bloc] is closed.
  @protected
  @mustCallSuper
  void onClose(BlocBase<dynamic> bloc) {}
}
