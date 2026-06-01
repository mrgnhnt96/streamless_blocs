import 'dart:async';

import 'package:streamless_bloc/bloc.dart';

import 'blocs.dart';

class AsyncCounterBloc extends Bloc<CounterEvent, int> {
  AsyncCounterBloc() : super(0) {
    on<CounterEvent>((event, emit) async {
      switch (event) {
        case CounterEvent.increment:
          await Future<void>.delayed(const Duration(microseconds: 1));
          return emit(state + 1);
      }
    });
  }
}
