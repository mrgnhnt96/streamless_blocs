part of bloc;

class _Handler<E, S> {
  const _Handler({
    required this.isType,
    required this.type,
    required this.handler,
    required this.transformer,
  });

  final bool Function(dynamic) isType;
  final Type type;
  final EventHandler<E, S> handler;
  final EventTransformer<E, S> transformer;
}
