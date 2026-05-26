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
import 'package:streamless_bloc/bloc.dart';

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

## Event Transformers

`streamless_bloc_concurrency` provides an opinionated set of event transformers:

- `concurrent` - process events concurrently
- `sequential` - process events sequentially
- `droppable` - ignore any events added while an event is processing
- `restartable` - process only the latest event and cancel previous event handlers
- `debounce(duration, eager: false)` - wait for a pause, then process only the latest event
  - Set `eager: true` to process the first event in a burst immediately, then debounce subsequent events
