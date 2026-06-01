import 'package:streamless_bloc/bloc.dart';

import 'counter_bloc.dart';

class SumEvent {
  const SumEvent(this.value);

  final int value;
}

class SumBloc extends Bloc<SumEvent, int> {
  SumBloc(this._counterBloc) : super(0) {
    on<SumEvent>((event, emit) => emit(state + event.value));
    _counterBloc.addListener(_onCounterStateChanged);
  }

  final CounterBloc _counterBloc;
  late final void Function(int) _onCounterStateChanged =
      (count) => add(SumEvent(count));

  @override
  Future<void> close() {
    _counterBloc.removeListener(_onCounterStateChanged);
    return super.close();
  }
}
