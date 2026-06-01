import 'package:streamless_bloc/bloc.dart';

class ExceptionCubit extends Cubit<int> {
  ExceptionCubit() : super(0);

  void throwException(Exception e) => throw e;
}
