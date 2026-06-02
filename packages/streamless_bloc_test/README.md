# streamless_bloc_test

A Dart package that makes testing streamless bloc and cubits easy. Built to work with [streamless_bloc](https://pub.dev/packages/streamless_bloc) and [mocktail](https://pub.dev/packages/mocktail).

This package mirrors the [bloc_test](https://pub.dev/packages/bloc_test) API, adapted for streamless bloc that use `addListener` instead of streams.

## Installation

```yaml
dev_dependencies:
  streamless_bloc_test: ^0.1.0
  mocktail: ^1.0.0
```

## Create a Mock

```dart
import 'package:streamless_bloc_test/streamless_bloc_test.dart';

class MockCounterBloc extends MockBloc<CounterEvent, int> implements CounterBloc {}
class MockCounterCubit extends MockCubit<int> implements CounterCubit {}
```

## Stub State Updates

**whenListen** stubs `addListener` on a mock bloc or cubit so listeners receive a canned `Stream` of states. It also keeps `state` in sync with the latest emitted value.

```dart
final counterBloc = MockCounterBloc();

whenListen(
  counterBloc,
  Stream.fromIterable([0, 1, 2, 3]),
  initialState: 0,
);

expect(counterBloc.state, equals(0));

final states = <int>[];
counterBloc.addListener(states.add);
await Future<void>.delayed(Duration.zero);

expect(states, [0, 1, 2, 3]);
expect(counterBloc.state, equals(3));
```

## Unit Test with blocTest

```dart
group('CounterBloc', () {
  blocTest(
    'emits [] when nothing is added',
    build: () => CounterBloc(),
    expect: () => [],
  );

  blocTest(
    'emits [1] when CounterIncrementPressed is added',
    build: () => CounterBloc(),
    act: (bloc) => bloc.add(CounterIncrementPressed()),
    expect: () => [1],
  );
});
```

See the [bloc_test documentation](https://pub.dev/packages/bloc_test) for the full `blocTest` API — the parameters and behavior are the same.
