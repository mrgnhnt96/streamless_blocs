import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:streamless_bloc/streamless_bloc.dart';

/// {@template bloc_selector}
/// [StreamlessBlocSelector] selects a value from the bloc state and rebuilds only when
/// the selected value changes.
/// {@endtemplate}
class StreamlessBlocSelector<B extends StreamlessBlocBase<S>, S, T>
    extends StatefulWidget {
  /// {@macro bloc_selector}
  const StreamlessBlocSelector({
    required this.selector,
    required this.builder,
    super.key,
    this.bloc,
  });

  final B? bloc;
  final T Function(S state) selector;
  final Widget Function(BuildContext context, T state) builder;

  @override
  State<StreamlessBlocSelector<B, S, T>> createState() =>
      _StreamlessBlocSelectorState<B, S, T>();
}

class _StreamlessBlocSelectorState<B extends StreamlessBlocBase<S>, S, T>
    extends State<StreamlessBlocSelector<B, S, T>> {
  late B _bloc;
  late T _value;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _value = widget.selector(_bloc.state);
    _bloc.addListener(_onState);
  }

  @override
  void didUpdateWidget(StreamlessBlocSelector<B, S, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc.removeListener(_onState);
      _bloc = bloc;
      _value = widget.selector(_bloc.state);
      _bloc.addListener(_onState);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc.removeListener(_onState);
      _bloc = bloc;
      _value = widget.selector(_bloc.state);
      _bloc.addListener(_onState);
    }
  }

  void _onState(S state) {
    final newValue = widget.selector(state);
    if (newValue != _value) {
      setState(() => _value = newValue);
    }
  }

  @override
  void dispose() {
    _bloc.removeListener(_onState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _value);
}
