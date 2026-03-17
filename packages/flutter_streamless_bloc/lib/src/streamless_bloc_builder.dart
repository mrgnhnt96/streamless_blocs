import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_streamless_bloc/src/types.dart';
import 'package:provider/provider.dart';
import 'package:streamless_bloc/streamless_bloc.dart';

import 'streamless_bloc_listener.dart';

/// {@template bloc_builder}
/// [StreamlessBlocBuilder] handles building a widget in response to new `states`.
///
/// [builder] respects [buildWhen] all except for the first build, where the current state is always provided.
/// {@endtemplate}
class StreamlessBlocBuilder<B extends StreamlessBlocBase<S>, S>
    extends StreamlessBlocBuilderBase<B, S> {
  /// {@macro bloc_builder}
  const StreamlessBlocBuilder({
    required this.builder,
    super.key,
    super.bloc,
    super.buildWhen,
  });

  final BlocWidgetBuilder<S> builder;

  @override
  Widget build(BuildContext context, S state) => builder(context, state);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<BlocWidgetBuilder<S>>.has('builder', builder),
    );
  }
}

/// Base class for widgets that build themselves based on a [bloc].
abstract class StreamlessBlocBuilderBase<B extends StreamlessBlocBase<S>, S>
    extends StatefulWidget {
  /// {@macro bloc_builder_base}
  const StreamlessBlocBuilderBase({super.key, this.bloc, this.buildWhen});

  final B? bloc;
  final BlocBuilderCondition<S>? buildWhen;

  Widget build(BuildContext context, S state);

  @override
  State<StreamlessBlocBuilderBase<B, S>> createState() =>
      _StreamlessBlocBuilderBaseState<B, S>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<BlocBuilderCondition<S>?>.has(
          'buildWhen',
          buildWhen,
        ),
      )
      ..add(DiagnosticsProperty<B?>('bloc', bloc));
  }
}

class _StreamlessBlocBuilderBaseState<B extends StreamlessBlocBase<S>, S>
    extends State<StreamlessBlocBuilderBase<B, S>> {
  late B _bloc;
  late S _state;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _state = _bloc.state;
  }

  @override
  void didUpdateWidget(StreamlessBlocBuilderBase<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
      _state = _bloc.state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _state = _bloc.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bloc == null) {
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return StreamlessBlocListener<B, S>(
      bloc: _bloc,
      listenWhen: widget.buildWhen,
      listener: (context, state) => setState(() => _state = state),
      child: widget.build(context, _state),
    );
  }
}
