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
import 'package:provider/single_child_widget.dart';
import 'package:streamless_bloc/bloc.dart';

/// {@template bloc_listener}
/// [BlocListener] invokes the [listener] in response to state changes.
/// {@endtemplate}
class BlocListener<B extends BlocBase<S>, S> extends BlocListenerBase<B, S> {
  /// {@macro bloc_listener}
  const BlocListener({
    required BlocWidgetListener<S> listener,
    super.key,
    B? bloc,
    BlocCondition<S>? listenWhen,
    Widget? child,
  }) : super(
         listener: listener,
         bloc: bloc,
         listenWhen: listenWhen,
         child: child,
       );
}

abstract class BlocListenerBase<B extends BlocBase<S>, S>
    extends SingleChildStatefulWidget {
  const BlocListenerBase({
    required this.listener,
    super.key,
    this.bloc,
    this.child,
    this.listenWhen,
  }) : super(child: child);

  final B? bloc;
  final BlocWidgetListener<S> listener;
  final BlocCondition<S>? listenWhen;
  final Widget? child;

  @override
  SingleChildState<BlocListenerBase<B, S>> createState() =>
      _BlocListenerBaseState<B, S>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<B?>('bloc', bloc))
      ..add(ObjectFlagProperty<BlocWidgetListener<S>>.has('listener', listener))
      ..add(
        ObjectFlagProperty<BlocCondition<S>?>.has('listenWhen', listenWhen),
      );
  }
}

class _BlocListenerBaseState<B extends BlocBase<S>, S>
    extends SingleChildState<BlocListenerBase<B, S>> {
  void Function(S)? _stateListener;
  late B _bloc;
  late S _previousState;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _previousState = _bloc.state;
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocListenerBase<B, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      if (_stateListener != null) {
        _unsubscribe();
        _bloc = currentBloc;
        _previousState = _bloc.state;
      }
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      if (_stateListener != null) {
        _unsubscribe();
        _bloc = bloc;
        _previousState = _bloc.state;
      }
      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '${widget.runtimeType} used outside of MultiBlocListener must specify a child',
    );
    if (widget.bloc == null) {
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return child!;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _stateListener = (state) {
      if (!mounted) return;
      if (widget.listenWhen?.call(_previousState, state) ?? true) {
        widget.listener(context, state);
      }
      _previousState = state;
    };
    if (_stateListener case final listener?) {
      _bloc.addListener(listener);
    }
  }

  void _unsubscribe() {
    if (_stateListener case final listener?) {
      _bloc.removeListener(listener);
      _stateListener = null;
    }
  }
}
