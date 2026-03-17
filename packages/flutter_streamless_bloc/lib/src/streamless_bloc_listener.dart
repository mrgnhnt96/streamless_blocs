import 'package:flutter/widgets.dart';
import 'package:flutter_streamless_bloc/src/types.dart';
import 'package:provider/provider.dart';
import 'package:streamless_bloc/streamless_bloc.dart';

/// {@template bloc_listener}
/// [StreamlessBlocListener] invokes the [listener] in response to state changes.
/// {@endtemplate}
class StreamlessBlocListener<B extends StreamlessBlocBase<S>, S>
    extends StatefulWidget {
  /// {@macro bloc_listener}
  const StreamlessBlocListener({
    required this.listener,
    super.key,
    this.bloc,
    this.listenWhen,
    required this.child,
  });

  final B? bloc;
  final BlocCondition<S>? listenWhen;
  final BlocWidgetListener<S> listener;
  final Widget child;

  @override
  State<StreamlessBlocListener<B, S>> createState() =>
      _StreamlessBlocListenerState<B, S>();
}

class _StreamlessBlocListenerState<B extends StreamlessBlocBase<S>, S>
    extends State<StreamlessBlocListener<B, S>> {
  B? _bloc;
  S? _previousState;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _previousState = _bloc!.state;
  }

  @override
  void didUpdateWidget(StreamlessBlocListener<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _previousState = bloc.state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _previousState = bloc.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BlocListenerScope<B, S>(
      bloc: _bloc!,
      listenWhen: widget.listenWhen,
      previousState: _previousState,
      listener: widget.listener,
      child: widget.child,
    );
  }
}

class _BlocListenerScope<B extends StreamlessBlocBase<S>, S>
    extends StatefulWidget {
  const _BlocListenerScope({
    required this.bloc,
    required this.listenWhen,
    required this.previousState,
    required this.listener,
    required this.child,
  });

  final B bloc;
  final BlocCondition<S>? listenWhen;
  final S? previousState;
  final BlocWidgetListener<S> listener;
  final Widget child;

  @override
  State<_BlocListenerScope<B, S>> createState() =>
      _BlocListenerScopeState<B, S>();
}

class _BlocListenerScopeState<B extends StreamlessBlocBase<S>, S>
    extends State<_BlocListenerScope<B, S>> {
  late S _previousState;

  @override
  void initState() {
    super.initState();
    _previousState = widget.previousState ?? widget.bloc.state;
    widget.bloc.addListener(_onState);
  }

  @override
  void didUpdateWidget(_BlocListenerScope<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bloc != widget.bloc) {
      oldWidget.bloc.removeListener(_onState);
      _previousState = widget.bloc.state;
      widget.bloc.addListener(_onState);
    }
  }

  void _onState(S state) {
    if (!mounted) return;
    final shouldListen = widget.listenWhen?.call(_previousState, state) ?? true;
    if (shouldListen) {
      widget.listener(context, state);
      _previousState = state;
    }
  }

  @override
  void dispose() {
    widget.bloc.removeListener(_onState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
