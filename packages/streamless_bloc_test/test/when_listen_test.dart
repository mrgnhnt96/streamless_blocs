import 'dart:async';

import 'package:streamless_bloc/bloc.dart';
import 'package:streamless_bloc_test/streamless_bloc_test.dart';
import 'package:test/test.dart';

import 'cubits/cubits.dart';

class MockCounterCubit extends MockCubit<int> implements CounterCubit {}

Future<List<T>> collectStates<T>(
  BlocBase<T> bloc, {
  Duration delay = Duration.zero,
}) async {
  final states = <T>[];
  bloc.addListener(states.add);
  await Future<void>.delayed(delay);
  return states;
}

void main() {
  group('whenListen', () {
    test('can mock state updates for a single cubit with an empty Stream', () async {
      final counterCubit = MockCounterCubit();
      whenListen(counterCubit, const Stream<int>.empty());
      final states = await collectStates(counterCubit);
      expect(states, isEmpty);
    });

    test('can mock state updates for a single cubit', () async {
      final counterCubit = MockCounterCubit();
      whenListen(
        counterCubit,
        Stream.fromIterable([0, 1, 2, 3]),
      );
      final states = await collectStates(counterCubit);
      expect(states, [0, 1, 2, 3]);
    });

    test('can mock state updates for a single cubit with delays', () async {
      final counterCubit = MockCounterCubit();
      final controller = StreamController<int>();
      whenListen(counterCubit, controller.stream);
      final states = <int>[];
      counterCubit.addListener(states.add);
      controller.add(0);
      await Future<void>.delayed(Duration.zero);
      controller.add(1);
      await Future<void>.delayed(Duration.zero);
      controller.add(2);
      await Future<void>.delayed(Duration.zero);
      controller.add(3);
      await controller.close();
      await Future<void>.delayed(Duration.zero);
      expect(states, [0, 1, 2, 3]);
    });

    test('can mock the state of a single cubit with delays', () async {
      final counterCubit = MockCounterCubit();
      final controller = StreamController<int>();
      whenListen(counterCubit, controller.stream);
      final states = <int>[];
      counterCubit.addListener(states.add);
      controller.add(0);
      await Future<void>.delayed(Duration.zero);
      controller.add(1);
      await Future<void>.delayed(Duration.zero);
      controller.add(2);
      await Future<void>.delayed(Duration.zero);
      controller.add(3);
      await controller.close();
      await Future<void>.delayed(Duration.zero);
      expect(states, [0, 1, 2, 3]);
      expect(counterCubit.state, equals(3));
    });

    test('can mock the state of a single cubit', () async {
      final counterCubit = MockCounterCubit();
      whenListen(
        counterCubit,
        Stream.fromIterable([0, 1, 2, 3]),
      );
      final states = await collectStates(counterCubit);
      expect(states, [0, 1, 2, 3]);
      expect(counterCubit.state, equals(3));
    });

    test('can mock the initial state of a single cubit', () async {
      final counterCubit = MockCounterCubit();
      whenListen(
        counterCubit,
        Stream.fromIterable([0, 1, 2, 3]),
        initialState: 0,
      );
      expect(counterCubit.state, equals(0));
      final states = await collectStates(counterCubit);
      expect(states, [0, 1, 2, 3]);
      expect(counterCubit.state, equals(3));
    });

    test('can mock state updates as a broadcast stream', () async {
      final counterCubit = MockCounterCubit();
      whenListen(
        counterCubit,
        Stream.fromIterable([0, 1, 2, 3]),
      );
      final firstStates = <int>[];
      final secondStates = <int>[];
      counterCubit.addListener(firstStates.add);
      counterCubit.addListener(secondStates.add);
      await Future<void>.delayed(Duration.zero);
      expect(firstStates, [0, 1, 2, 3]);
      expect(secondStates, [0, 1, 2, 3]);
    });

    test(
      'can mock state updates of a cubit dependency (with initial state)',
      () async {
        final controller = StreamController<int>();
        final counterCubit = MockCounterCubit();
        whenListen(counterCubit, controller.stream);
        final sumCubit = SumCubit(counterCubit);
        final sumStates = <int>[];
        sumCubit.addListener(sumStates.add);
        controller
          ..add(0)
          ..add(1)
          ..add(2)
          ..add(3);
        await controller.close();
        await Future<void>.delayed(Duration.zero);
        expect(sumStates, [0, 1, 3, 6]);
        expect(sumCubit.state, equals(6));
        await sumCubit.close();
      },
    );

    test('can mock state updates of a cubit dependency', () async {
      final controller = StreamController<int>();
      final counterCubit = MockCounterCubit();
      whenListen(counterCubit, controller.stream);
      final sumCubit = SumCubit(counterCubit);
      final sumStates = <int>[];
      sumCubit.addListener(sumStates.add);
      controller
        ..add(1)
        ..add(2)
        ..add(3);
      await controller.close();
      await Future<void>.delayed(Duration.zero);
      expect(sumStates, [1, 3, 6]);
      expect(sumCubit.state, equals(6));
      await sumCubit.close();
    });
  });
}
