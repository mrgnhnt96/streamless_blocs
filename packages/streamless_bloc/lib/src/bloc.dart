import 'dart:async';

import 'package:meta/meta.dart';
import 'package:streamless_bloc/src/bloc_base.dart';
import 'package:streamless_bloc/src/bloc_event_sink.dart';
import 'package:streamless_bloc/src/event_handler.dart';
import 'package:streamless_bloc/src/transition.dart';

/// {@template emitter}
/// An [Emitter] is a class which is capable of emitting new states.
/// {@endtemplate}
abstract class Emitter<State> {
  /// Whether the [EventHandler] associated with this [Emitter] has completed.
  bool get isDone;

  /// Emits the provided [state].
  void call(State state);
}

class _Handler<E, S> {
  const _Handler({
    required this.isType,
    required this.type,
    required this.handler,
    required this.transformer,
  });

  final bool Function(dynamic) isType;
  final Type type;
  final EventHandler<E, S> handler;
  final EventTransformer<E, S> transformer;
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

/// {@template bloc}
/// Takes events as input and transforms them into states as output.
/// Processes events via a queue (no streams).
/// {@endtemplate}
abstract class Bloc<Event, State> extends BlocBase<State>
    implements BlocEventSink<Event> {
  /// {@macro bloc}
  Bloc(super.initialState);

  /// The current [BlocObserver] instance.
  static BlocObserver get observer => BlocBase.observer;

  static set observer(BlocObserver value) => BlocBase.observer = value;

  static EventTransformer<dynamic, dynamic> transformer =
      (event, mapper, emit) async {
        await mapper(event, emit);
      };

  final List<_Handler<Event, State>> _handlers = [];
  final List<Event> _eventQueue = [];
  final List<_Emitter<State>> _emitters = [];
  bool _isProcessing = false;

  @override
  void add(Event event) {
    final handlerExists = _handlers.any((h) => h.isType(event));
    if (!handlerExists) {
      throw StateError(
        'add(${event.runtimeType}) was called without a registered event '
        'handler.\nMake sure to register a handler via '
        'on<${event.runtimeType}>((event, emit) {...})',
      );
    }
    if (isClosed) {
      throw StateError('Cannot add new events after calling close');
    }

    try {
      onEvent(event);
      _eventQueue.add(event);
      unawaited(_processEvents());
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      rethrow;
    }
  }

  @protected
  @mustCallSuper
  void onEvent(Event event) {
    // ignore: invalid_use_of_protected_member
    blocObserver.onEvent(this, event);
  }

  /// Register event handler for an event of type `E`.
  void on<E extends Event>(
    EventHandler<E, State> handler, {
    EventTransformer<E, State>? transformer,
  }) {
    final handlerExists = _handlers.any((h) => h.type == E);
    if (handlerExists) {
      throw StateError(
        'on<$E> was called multiple times. '
        'There should only be a single event handler per event type.',
      );
    }

    _handlers.add(
      _Handler<E, State>(
        isType: (e) => e is E,
        type: E,
        handler: handler,
        transformer:
            transformer ?? Bloc.transformer as EventTransformer<E, State>,
      ),
    );
  }

  Future<void> _processEvents() async {
    if (_isProcessing || _eventQueue.isEmpty || isClosed) return;
    _isProcessing = true;
    try {
      while (_eventQueue.isNotEmpty && !isClosed) {
        final event = _eventQueue.removeAt(0);
        _Handler<dynamic, State>? handler;
        for (final h in _handlers) {
          if (h.isType(event)) {
            handler = h;
            break;
          }
        }
        if (handler == null) continue;
        unawaited(_dispatchEvent(handler, event));
      }
    } finally {
      _isProcessing = false;
      if (_eventQueue.isNotEmpty && !isClosed) {
        unawaited(_processEvents());
      }
    }
  }

  Future<void> _dispatchEvent(
    _Handler<dynamic, State> handler,
    Event event,
  ) async {
    final (emitter, complete) = createEmitter<State>((state) {
      if (isClosed) return;

      onTransition(
        Transition<Event, State>(
          currentState: this.state,
          event: event,
          nextState: state,
        ),
      );

      emit(state);
    });

    _emitters.add(emitter);
    try {
      await handler.transformer(event, handler.handler, emitter);
      onDone(event);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      onDone(event, error, stackTrace);
      rethrow;
    } finally {
      complete();
      _emitters.remove(emitter);
    }
  }

  @protected
  @mustCallSuper
  void onTransition(Transition<Event, State> transition) {
    // ignore: invalid_use_of_protected_member
    blocObserver.onTransition(this, transition);
  }

  @protected
  @mustCallSuper
  void onDone(Event event, [Object? error, StackTrace? stackTrace]) {
    // ignore: invalid_use_of_protected_member
    blocObserver.onDone(this, event, error, stackTrace);
  }

  @mustCallSuper
  @override
  Future<void> close() async {
    for (final emitter in List.from(_emitters)) {
      emitter.cancel();
    }
    await Future.wait<void>(_emitters.map((e) => e.future));
    await super.close();
  }
}
