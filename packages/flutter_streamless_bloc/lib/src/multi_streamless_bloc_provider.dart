import 'package:flutter/widgets.dart' show Widget;
import 'package:provider/provider.dart';

import 'streamless_bloc_provider.dart';

/// {@template multi_bloc_provider}
/// Merges multiple [StreamlessBlocProvider] widgets into one widget tree.
///
/// [MultiStreamlessBlocProvider] improves the readability and eliminates the need
/// to nest multiple [StreamlessBlocProvider]s.
///
/// By using [MultiStreamlessBlocProvider] we can go from:
///
/// ```dart
/// StreamlessBlocProvider<BlocA>(
///   create: (BuildContext context) => BlocA(),
///   child: StreamlessBlocProvider<BlocB>(
///     create: (BuildContext context) => BlocB(),
///     child: StreamlessBlocProvider<BlocC>(
///       create: (BuildContext context) => BlocC(),
///       child: ChildA(),
///     )
///   )
/// )
/// ```
///
/// to:
///
/// ```dart
/// MultiStreamlessBlocProvider(
///   providers: [
///     StreamlessBlocProvider<BlocA>(
///       create: (BuildContext context) => BlocA(),
///     ),
///     StreamlessBlocProvider<BlocB>(
///       create: (BuildContext context) => BlocB(),
///     ),
///     StreamlessBlocProvider<BlocC>(
///       create: (BuildContext context) => BlocC(),
///     ),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [MultiStreamlessBlocProvider] converts the [StreamlessBlocProvider] list into a tree of nested
/// [StreamlessBlocProvider] widgets.
/// As a result, the only advantage of using [MultiStreamlessBlocProvider] is improved
/// readability due to the reduction in nesting and boilerplate.
/// {@endtemplate}
class MultiStreamlessBlocProvider extends MultiProvider {
  /// {@macro multi_bloc_provider}
  MultiStreamlessBlocProvider({
    required super.providers,
    required Widget super.child,
    super.key,
  });
}
