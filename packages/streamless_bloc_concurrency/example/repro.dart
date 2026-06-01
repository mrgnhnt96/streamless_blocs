import 'package:streamless_bloc/bloc.dart';
import 'package:streamless_bloc_concurrency/bloc_concurrency.dart';

sealed class AppBadgeEvent {}

class _Update extends AppBadgeEvent {}

class AppBadgeState {
  const AppBadgeState({this.count = 0});
  final int count;
}

void main() {
  print('Testing default transformer...');
  try {
    _DefaultBloc();
    print('default: OK');
  } catch (e) {
    print('default: FAILED: $e');
  }

  print('Testing debounce transformer...');
  try {
    _DebounceBloc();
    print('debounce: OK');
  } catch (e) {
    print('debounce: FAILED: $e');
  }
}

class _DefaultBloc extends Bloc<AppBadgeEvent, AppBadgeState> {
  _DefaultBloc() : super(const AppBadgeState()) {
    on<_Update>((event, emit) {
      emit(AppBadgeState(count: state.count + 1));
    });
  }
}

class _DebounceBloc extends Bloc<AppBadgeEvent, AppBadgeState> {
  _DebounceBloc() : super(const AppBadgeState()) {
    on<_Update>(
      (event, emit) {
        emit(AppBadgeState(count: state.count + 1));
      },
      transformer: debounce(duration: const Duration(milliseconds: 300)),
    );
  }
}
