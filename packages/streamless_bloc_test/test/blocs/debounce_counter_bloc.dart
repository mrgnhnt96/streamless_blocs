import 'package:streamless_bloc/bloc.dart';
import 'package:streamless_bloc_concurrency/bloc_concurrency.dart';

import 'blocs.dart';

class DebounceCounterBloc extends Bloc<CounterEvent, int> {
  DebounceCounterBloc() : super(0) {
    on<CounterEvent>(
      (event, emit) {
        switch (event) {
          case CounterEvent.increment:
            return emit(state + 1);
        }
      },
      transformer: debounce(duration: const Duration(milliseconds: 300)),
    );
  }
}
