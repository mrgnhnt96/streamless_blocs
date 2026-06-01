import 'package:mocktail/mocktail.dart';
import 'package:streamless_bloc/bloc.dart';

/// {@template mock_bloc}
/// Extend or mixin this class to mark the implementation as a [MockBloc].
/// {@endtemplate}
class MockBloc<E, S> extends _MockBlocBase<S> implements Bloc<E, S> {}

/// {@template mock_cubit}
/// Extend or mixin this class to mark the implementation as a [MockCubit].
/// {@endtemplate}
class MockCubit<S> extends _MockBlocBase<S> implements Cubit<S> {}

class _MockBlocBase<S> extends Mock implements BlocBase<S> {
  _MockBlocBase() {
    when(() => addListener(any())).thenReturn(null);
    when(() => removeListener(any())).thenReturn(null);
    when(close).thenAnswer((_) => Future<void>.value());
  }
}
