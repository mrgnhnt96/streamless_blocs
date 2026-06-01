import 'dart:async';

import 'package:streamless_bloc/bloc.dart';

import 'blocs.dart';

class InstantEmitBloc extends Bloc<CounterEvent, int> {
  InstantEmitBloc() : super(0) {
    on<CounterEvent>((event, emit) {
      switch (event) {
        case CounterEvent.increment:
          return emit(state + 1);
      }
    });
    scheduleMicrotask(() => add(CounterEvent.increment));
  }
}
