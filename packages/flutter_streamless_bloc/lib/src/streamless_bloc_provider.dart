import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:streamless_bloc/streamless_bloc.dart';

/// {@template bloc_provider}
/// Takes a `create` function that is responsible for creating the [Bloc] or
/// [Cubit] and a [child] which will have access to the instance via
/// `BlocProvider.of(context)`.
/// {@endtemplate}
class StreamlessBlocProvider<T extends StreamlessBlocBase<Object?>>
    extends SingleChildStatelessWidget {
  /// {@macro bloc_provider}
  const StreamlessBlocProvider({
    required T Function(BuildContext context) create,
    super.key,
    this.child,
    this.lazy = true,
  }) : _create = create,
       _value = null,
       super(child: child);

  /// Provides an existing [value] to a subtree.
  const StreamlessBlocProvider.value({required T value, super.key, this.child})
    : _value = value,
      _create = null,
      lazy = true,
      super(child: child);

  /// Widget which will have access to the [Bloc] or [Cubit].
  final Widget? child;

  /// Whether the [Bloc] or [Cubit] should be created lazily.
  final bool lazy;

  final T Function(BuildContext context)? _create;
  final T? _value;

  /// Returns the [Bloc] or [Cubit] from the current context.
  static T of<T extends StreamlessBlocBase<Object?>>(
    BuildContext context, {
    bool listen = false,
  }) {
    try {
      return Provider.of<T>(context, listen: listen);
    } on ProviderNotFoundException catch (e) {
      if (e.valueType != T) rethrow;
      throw FlutterError(
        'BlocProvider.of() called with a context that does not contain a $T.',
      );
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '$runtimeType used outside of MultiBlocProvider must specify a child',
    );
    final value = _value;
    return value != null
        ? InheritedProvider<T>.value(
            value: value,
            startListening: _startListening,
            child: child,
          )
        : InheritedProvider<T>(
            create: _create!,
            dispose: (_, bloc) => bloc.close(),
            startListening: _startListening,
            lazy: lazy,
            child: child,
          );
  }

  static VoidCallback _startListening<T extends StreamlessBlocBase<Object?>>(
    InheritedContext<T?> e,
    T value,
  ) {
    final listener = (_) => e.markNeedsNotifyDependents();

    value.addListener(listener);
    return () => value.removeListener(listener);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('lazy', lazy));
  }
}
