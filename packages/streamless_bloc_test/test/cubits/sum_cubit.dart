import 'package:streamless_bloc/bloc.dart';

import 'counter_cubit.dart';

class SumCubit extends Cubit<int> {
  SumCubit(this._counterCubit) : super(0) {
    _counterCubit.addListener(_onCounterStateChanged);
  }

  final CounterCubit _counterCubit;
  late final void Function(int) _onCounterStateChanged =
      (count) => emit(state + count);

  @override
  Future<void> close() {
    _counterCubit.removeListener(_onCounterStateChanged);
    return super.close();
  }
}
