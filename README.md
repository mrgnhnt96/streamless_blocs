# Streamless Blocs (streamless_bloc)

A predictable state management library that **replicates the bloc interface exactly** but removes the use of streams for event processing. Uses a simple queue-based approach instead of stream transformers.

## Packages

- **streamless_bloc** - Core Dart package (no Flutter dependency)
- **flutter_streamless_bloc** - Flutter widgets for integrating streamless_bloc into your app
- **streamless_bloc_concurrency** - Event transformers for concurrent event handling

## Why streamless_bloc?

The standard [bloc](https://bloclibrary.dev) package uses Dart streams extensively for both state propagation and event processing. streamless_bloc provides the same API (`Bloc`, `Cubit`, `BlocBase`, `emit`, `add`, `onChange`, etc.) but uses:

- **Queue-based event processing** - Events are processed from a simple queue instead of stream transformers
- **Minimal stream usage** - State still exposes a `stream` getter for Flutter widget compatibility (used by `BlocBuilder`, etc.)

## Getting Started

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  streamless_bloc: ^0.1.0
  flutter_streamless_bloc: ^0.1.0 # For Flutter apps
```

### Usage

Works exactly like bloc:

```dart
// Cubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}

// Bloc
sealed class CounterEvent {}
final class CounterIncrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) => emit(state + 1));
  }
}
```

### Flutter

```dart
BlocProvider(
  create: (_) => CounterCubit(),
  child: BlocBuilder<CounterCubit, int>(
    builder: (context, count) => Text('$count'),
  ),
)
```

## Version Pinning (FVM)

This project uses [FVM](https://fvm.app) to pin the Flutter version:

```bash
fvm use stable  # or fvm use 3.38.9
```

## License

MIT
