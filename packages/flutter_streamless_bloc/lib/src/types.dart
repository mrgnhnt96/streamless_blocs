/*
 * Originally derived from the Bloc package:
 * https://github.com/felangel/bloc
 * Copyright (c) 2019-present Felix Angelov
 * Modified for Streamless Blocs.
 */

import 'package:flutter/widgets.dart' show Widget, BuildContext;

/// Signature for the `builder` function.
typedef BlocWidgetBuilder<S> = Widget Function(BuildContext context, S state);

/// Signature for the `listener` function.
typedef BlocWidgetListener<S> = void Function(BuildContext context, S state);

/// Signature for the `listenWhen` and `buildWhen` functions.
typedef BlocCondition<S> = bool Function(S previous, S current);
