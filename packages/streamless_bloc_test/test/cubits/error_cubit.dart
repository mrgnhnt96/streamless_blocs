import 'package:streamless_bloc/bloc.dart';

class ErrorCubit extends Cubit<int> {
  ErrorCubit() : super(0);

  void throwError(Error e) => throw e;
}
