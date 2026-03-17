# flutter_streamless_bloc

Flutter widgets for the [streamless_bloc](https://pub.dev/packages/streamless_bloc) state management library. Built to work with the streamless bloc interface.

## Installation

```yaml
dependencies:
  streamless_bloc: ^0.1.0
  flutter_streamless_bloc: ^0.1.0
```

## Widgets

- **BlocProvider** - Provides a bloc/cubit to the widget tree
- **BlocBuilder** - Rebuilds when state changes
- **BlocListener** - Listens to state changes (e.g. for navigation, dialogs)
- **BlocConsumer** - Combines BlocListener and BlocBuilder
- **BlocSelector** - Rebuilds only when selected value changes

## Usage

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
}

// In your app
BlocProvider(
  create: (_) => CounterCubit(),
  child: BlocBuilder<CounterCubit, int>(
    builder: (context, count) => Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => context.read<CounterCubit>().increment(),
          child: Text('Increment'),
        ),
      ],
    ),
  ),
)
```

## License

MIT
