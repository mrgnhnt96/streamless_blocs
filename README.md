# Streamless Blocs (streamless_bloc)

A predictable state management library that **replicates the bloc interface exactly** but removes the use of streams for event processing — preserving the original stack traces when event handlers throw.

## Packages

- **streamless_bloc** - Core Dart package (no Flutter dependency)
- **flutter_streamless_bloc** - Flutter widgets for integrating streamless_bloc into your app
- **streamless_bloc_concurrency** - Event transformers for concurrent event handling
- **streamless_bloc_test** - Testing utilities (mirrors bloc_test for streamless blocs)

## Why streamless_bloc?

The standard [bloc](https://bloclibrary.dev) package routes event processing through Dart streams and stream transformers. When an event handler throws, that error passes through async stream machinery — listeners, subscriptions, and nested transformers — which often replaces the original stack trace with one pointing at stream internals. That makes production debugging and crash reporting much harder.

**streamless_bloc exists to preserve stack traces.** It provides the same API (`Bloc`, `Cubit`, `BlocBase`, `emit`, `add`, `onChange`, etc.) but processes events through a direct queue and `Future` chain instead of streams. Errors are caught at the handler boundary with their original `StackTrace` intact and forwarded to `BlocObserver.onError` / `onDone`.

Under the hood:

- **Queue-based event processing** — Events are processed from a simple queue instead of stream transformers

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
