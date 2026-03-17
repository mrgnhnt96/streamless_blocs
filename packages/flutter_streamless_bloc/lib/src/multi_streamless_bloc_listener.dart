import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'streamless_bloc_listener.dart';

/// {@template multi_bloc_listener}
/// Merges multiple [StreamlessBlocListener] widgets into one widget tree.
///
/// [MultiStreamlessBlocListener] improves the readability and eliminates the need
/// to nest multiple [StreamlessBlocListener]s.
///
/// By using [MultiStreamlessBlocListener] we can go from:
///
/// ```dart
/// StreamlessBlocListener<BlocA, BlocAState>(
///   listener: (context, state) {},
///   child: StreamlessBlocListener<BlocB, BlocBState>(
///     listener: (context, state) {},
///     child: StreamlessBlocListener<BlocC, BlocCState>(
///       listener: (context, state) {},
///       child: ChildA(),
///     ),
///   ),
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiBlocListener(
///   listeners: [
///     StreamlessBlocListener<BlocA, BlocAState>(
///       listener: (context, state) {},
///     ),
///     StreamlessBlocListener<BlocB, BlocBState>(
///       listener: (context, state) {},
///     ),
///     StreamlessBlocListener<BlocC, BlocCState>(
///       listener: (context, state) {},
///     ),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [MultiStreamlessBlocListener] converts the [StreamlessBlocListener] list into a tree of nested
/// [StreamlessBlocListener] widgets. \
/// As a result, the only advantage of using [MultiStreamlessBlocListener] is improved
/// readability due to the reduction in nesting and boilerplate.
/// {@endtemplate}
class MultiStreamlessBlocListener extends MultiProvider {
  /// {@macro multi_bloc_listener}
  MultiStreamlessBlocListener({
    required List<SingleChildWidget> listeners,
    required Widget super.child,
    super.key,
  }) : super(providers: listeners);
}
