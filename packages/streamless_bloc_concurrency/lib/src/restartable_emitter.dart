import 'package:streamless_bloc/bloc.dart';

/// An [Emitter] that ignores emits once a newer event has superseded it.
class RestartableEmitter<State> implements Emitter<State> {
  const RestartableEmitter(this._delegate, this._isStale);

  final Emitter<State> _delegate;
  final bool Function() _isStale;

  @override
  bool get isDone => _delegate.isDone || _isStale();

  @override
  void call(State state) {
    if (!_isStale() && !_delegate.isDone) {
      _delegate(state);
    }
  }
}
