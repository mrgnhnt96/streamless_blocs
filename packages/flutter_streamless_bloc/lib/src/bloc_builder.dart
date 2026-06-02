/*
 * Originally derived from the Bloc package:
 * https://github.com/felangel/bloc
 * Copyright (c) 2019-present Felix Angelov
 * Modified for Streamless Blocs.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_streamless_bloc/src/types.dart';
import 'package:provider/provider.dart';
import 'package:streamless_bloc/bloc.dart';

import 'bloc_listener.dart';

/// {@template bloc_builder}
/// [BlocBuilder] handles building a widget in response to new `states`.
///
/// [builder] respects [buildWhen] all except for the first build, where the current state is always provided.
/// {@endtemplate}
class BlocBuilder<B extends BlocBase<S>, S> extends BlocBuilderBase<B, S> {
  /// {@macro bloc_builder}
  const BlocBuilder({
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
abstract class BlocBuilderBase<B extends BlocBase<S>, S> extends StatefulWidget {
  /// {@macro bloc_builder_base}
  const BlocBuilderBase({super.key, this.bloc, this.buildWhen});

  final B? bloc;
  final BlocCondition<S>? buildWhen;

  Widget build(BuildContext context, S state);

  @override
  State<BlocBuilderBase<B, S>> createState() => _BlocBuilderBaseState<B, S>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ObjectFlagProperty<BlocCondition<S>?>.has('buildWhen', buildWhen))
      ..add(DiagnosticsProperty<B?>('bloc', bloc));
  }
}

class _BlocBuilderBaseState<B extends BlocBase<S>, S>
    extends State<BlocBuilderBase<B, S>> {
  late B _bloc;
  late S _state;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _state = _bloc.state;
  }

  @override
  void didUpdateWidget(BlocBuilderBase<B, S> oldWidget) {
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
    return BlocListener<B, S>(
      bloc: _bloc,
      listenWhen: widget.buildWhen,
      listener: (context, state) => setState(() => _state = state),
      child: widget.build(context, _state),
    );
  }
}
