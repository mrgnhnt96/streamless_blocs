import 'package:flutter/widgets.dart';
import 'package:flutter_streamless_bloc/src/types.dart';
import 'package:streamless_bloc/streamless_bloc.dart';

import 'streamless_bloc_builder.dart';
import 'streamless_bloc_listener.dart';

/// {@template bloc_consumer}
/// [StreamlessBlocConsumer] exposes a [builder] and [listener] to react to new states.
/// {@endtemplate}
class StreamlessBlocConsumer<B extends StreamlessBlocBase<S>, S>
    extends StatelessWidget {
  /// {@macro bloc_consumer}
  const StreamlessBlocConsumer({
    required this.listener,
    required this.builder,
    super.key,
    this.bloc,
    this.buildWhen,
    this.listenWhen,
  });

  final B? bloc;
  final BlocWidgetListener<S> listener;
  final BlocWidgetBuilder<S> builder;
  final BlocCondition<S>? buildWhen;
  final BlocCondition<S>? listenWhen;

  @override
  Widget build(BuildContext context) {
    return StreamlessBlocListener<B, S>(
      bloc: bloc,
      listenWhen: listenWhen,
      listener: listener,
      child: StreamlessBlocBuilder<B, S>(
        bloc: bloc,
        buildWhen: buildWhen,
        builder: builder,
      ),
    );
  }
}
