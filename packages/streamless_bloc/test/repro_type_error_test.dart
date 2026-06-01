import 'package:streamless_bloc/bloc.dart';
import 'package:streamless_bloc_concurrency/bloc_concurrency.dart';
import 'package:test/test.dart';

sealed class AppBadgeEvent {}

class _Update extends AppBadgeEvent {}

class AppBadgeState {
  const AppBadgeState({this.count = 0});
  final int count;
}

class AppBadgeBlocDefault extends Bloc<AppBadgeEvent, AppBadgeState> {
  AppBadgeBlocDefault() : super(const AppBadgeState()) {
    on<_Update>((event, emit) {
      emit(AppBadgeState(count: state.count + 1));
    });
  }
}

class AppBadgeBlocDebounce extends Bloc<AppBadgeEvent, AppBadgeState> {
  AppBadgeBlocDebounce() : super(const AppBadgeState()) {
    on<_Update>(
      (event, emit) {
        emit(AppBadgeState(count: state.count + 1));
      },
      transformer: debounce(duration: const Duration(milliseconds: 300)),
    );
  }
}

void main() {
  test('default transformer', () {
    expect(() => AppBadgeBlocDefault(), returnsNormally);
  });

  test('debounce transformer', () {
    expect(() => AppBadgeBlocDebounce(), returnsNormally);
  });
}
