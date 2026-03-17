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
(Emitter<State> emitter, void Function() complete) createEmitter<State>(
  void Function(State) onEmit,
) {
  final instance = _Emitter<State>(onEmit);
  return (instance, () => instance.complete());
}

class _Emitter<State> implements Emitter<State> {
  _Emitter(this._onEmit);

  final void Function(State state) _onEmit;
  bool _isCompleted = false;

  @override
  bool get isDone => _isCompleted;

  @override
  void call(State state) {
    assert(
      !_isCompleted,
      'emit was called after an event handler completed. '
      'Please ensure all async operations are awaited.',
    );
    if (!_isCompleted) _onEmit(state);
  }

  void complete() {
    _isCompleted = true;
  }
}
