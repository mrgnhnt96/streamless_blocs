/*
 * Originally derived from the Bloc package:
 * https://github.com/felangel/bloc
 * Copyright (c) 2019-present Felix Angelov
 * Modified for Streamless Blocs.
 */

abstract class BlocEventSink<Event> {
  /// Adds an [event] to the sink.
  void add(Event event);
}
