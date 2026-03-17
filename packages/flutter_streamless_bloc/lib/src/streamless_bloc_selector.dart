import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_streamless_bloc/src/types.dart';
import 'package:provider/provider.dart';
import 'package:streamless_bloc/streamless_bloc.dart';

import 'streamless_bloc_listener.dart';

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
  final BlocWidgetBuilder<T> builder;

  @override
  State<StreamlessBlocSelector<B, S, T>> createState() =>
      _StreamlessBlocSelectorState<B, S, T>();
}

class _StreamlessBlocSelectorState<B extends StreamlessBlocBase<S>, S, T>
    extends State<StreamlessBlocSelector<B, S, T>> {
  late B _bloc;
  late T _state;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _state = widget.selector(_bloc.state);
  }

  @override
  void didUpdateWidget(StreamlessBlocSelector<B, S, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      _bloc = currentBloc;
      _state = widget.selector(_bloc.state);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      _bloc = bloc;
      _state = widget.selector(_bloc.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bloc == null) {
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return StreamlessBlocListener<B, S>(
      bloc: _bloc,
      listener: (context, state) {
        final selectedState = widget.selector(state);
        if (_state != selectedState) {
          setState(() => _state = selectedState);
        }
      },
      child: widget.builder(context, _state),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<B?>('bloc', widget.bloc))
      ..add(ObjectFlagProperty<BlocWidgetBuilder<T>>.has('builder', widget.builder))
      ..add(ObjectFlagProperty<T Function(S)>.has('selector', widget.selector));
  }
}
