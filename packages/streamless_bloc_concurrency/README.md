# streamless_bloc_concurrency

Event transformers for `streamless_bloc` to control how events are processed.

## Installation

```yaml
dependencies:
  streamless_bloc_concurrency: ^0.1.0
```

## Usage

```dart
import 'package:streamless_bloc_concurrency/bloc_concurrency.dart';
import 'package:streamless_bloc/streamless_bloc.dart';

sealed class CounterEvent {}
final class Increment extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>(
      (event, emit) async => emit(state + 1),
      transformer: sequential(),
    );
  }
}
```

## Available transformers

- `concurrent` - process events concurrently
- `sequential` - process events one at a time in arrival order
- `droppable` - ignore incoming events while one is in progress
- `debounce(duration)` - wait for a pause, then process only the latest event
- `restartable` - keep only the latest event and ignore stale emits
