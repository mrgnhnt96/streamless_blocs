import 'dart:async';

import 'package:mocktail/mocktail.dart';
import 'package:streamless_bloc/bloc.dart';

/// Creates a stub response for the `addListener` method on a [bloc].
/// Use [whenListen] if you want to invoke listeners with a canned `Stream`
/// of states for a [bloc] instance.
///
/// [whenListen] also handles stubbing the `state` of the [bloc] to stay
/// in sync with the emitted state.
void whenListen<State>(
  BlocBase<State> bloc,
  Stream<State> stream, {
  State? initialState,
}) {
  final broadcastStream = stream.asBroadcastStream();
  final listenerSubscriptions =
      <void Function(State), StreamSubscription<State>>{};

  if (initialState != null) {
    when(() => bloc.state).thenReturn(initialState);
  }

  when(() => bloc.addListener(any())).thenAnswer((invocation) {
    final listener =
        invocation.positionalArguments[0] as void Function(State);
    listenerSubscriptions[listener] = broadcastStream.listen((state) {
      when(() => bloc.state).thenReturn(state);
      listener(state);
    });
  });

  when(() => bloc.removeListener(any())).thenAnswer((invocation) {
    final listener =
        invocation.positionalArguments[0] as void Function(State);
    listenerSubscriptions.remove(listener)?.cancel();
  });
}
