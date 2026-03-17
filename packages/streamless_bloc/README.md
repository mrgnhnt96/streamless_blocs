# streamless_bloc

A predictable state management library that replicates the bloc interface exactly but removes the use of streams for event processing.

## Features

- **Drop-in API** - Same interface as [bloc](https://bloclibrary.dev): `Bloc`, `Cubit`, `BlocBase`, `emit`, `add`, `onChange`, `BlocObserver`, etc.
- **Streamless event processing** - Events are processed from a queue instead of stream transformers
- **Pure Dart** - No Flutter dependency; use in any Dart project

## Installation

```yaml
dependencies:
  streamless_bloc: ^0.1.0
```

## Usage

### Cubit

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}

void main() {
  final cubit = CounterCubit();
  print(cubit.state); // 0
  cubit.increment();
  print(cubit.state); // 1
  cubit.close();
}
```

### Bloc

```dart
sealed class CounterEvent {}
final class CounterIncrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
  }
}

Future<void> main() async {
  final bloc = CounterBloc();
  print(bloc.state); // 0
  bloc.add(CounterIncrementPressed());
  await Future.delayed(Duration.zero);
  print(bloc.state); // 1
  await bloc.close();
}
```

## License

MIT
