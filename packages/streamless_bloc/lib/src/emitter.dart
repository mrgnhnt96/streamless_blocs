part of streamless_bloc;

/// {@template emitter}
/// An [Emitter] is a class which is capable of emitting new states.
/// {@endtemplate}
abstract class Emitter<State> {
  /// Whether the [EventHandler] associated with this [Emitter] has completed.
  bool get isDone;

  /// Emits the provided [state].
  void call(State state);
}

/// Creates an [Emitter] for use in event handlers.
/// Returns both the emitter and a complete callback.
(_Emitter<State> emitter, void Function() complete) createEmitter<State>(
  void Function(State) onEmit,
) {
  final instance = _Emitter<State>(onEmit);
  return (instance, () => instance.complete());
}

class _Emitter<State> implements Emitter<State> {
  _Emitter(this._onEmit);

  final void Function(State) _onEmit;
  final _completer = Completer<void>();
  bool _isCompleted = false;

  @override
  void call(State state) {
    assert(
      !_isCompleted,
      'emit was called after an event handler completed. '
      'Please ensure all async operations are awaited.',
    );
    if (!_isCompleted) _onEmit(state);
  }

  @override
  bool get isDone => _isCompleted;

  void cancel() {
    complete();
  }

  void complete() {
    if (isDone) return;
    _isCompleted = true;
    _close();
  }

  void _close() {
    if (!_completer.isCompleted) {
      _completer.complete();
    }
  }

  Future<void> get future => _completer.future;
}
