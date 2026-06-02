/*
 * Originally derived from the Bloc package:
 * https://github.com/felangel/bloc
 * Copyright (c) 2019-present Felix Angelov
 * Modified for Streamless Blocs.
 */

import 'package:meta/meta.dart';
import 'package:streamless_bloc/src/change.dart';

/// {@template transition}
/// A [Transition] is the change from one state to another.
/// Consists of the [currentState], an [event], and the [nextState].
/// {@endtemplate}
@immutable
class Transition<Event, State> extends Change<State> {
  /// {@macro transition}
  const Transition({
    required super.currentState,
    required this.event,
    required super.nextState,
  });

  /// The [Event] which triggered the current [Transition].
  final Event event;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transition<Event, State> &&
          runtimeType == other.runtimeType &&
          currentState == other.currentState &&
          event == other.event &&
          nextState == other.nextState;

  @override
  int get hashCode => Object.hashAll([currentState, event, nextState]);

  @override
  String toString() {
    return 'Transition { currentState: $currentState, event: $event, nextState: $nextState }';
  }
}
