import 'package:streamless_bloc/bloc.dart';

/// Process events concurrently.
///
/// **Note**: there may be event handler overlap and state changes will occur
/// as soon as they are emitted. This means that states may be emitted in
/// an order that does not match the order in which the corresponding events
/// were added.
EventTransformer<Event, State> concurrent<Event, State>() {
  return (event, mapper, emit) async {
    await mapper(event, emit);
  };
}
