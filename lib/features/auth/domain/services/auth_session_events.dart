import 'dart:async';

abstract interface class AuthSessionEvents {
  Stream<void> get expired;
  void notifyExpired();
}

final class AuthSessionEventBus implements AuthSessionEvents {
  final _controller = StreamController<void>.broadcast(sync: true);

  @override
  Stream<void> get expired => _controller.stream;

  @override
  void notifyExpired() => _controller.add(null);

  Future<void> dispose() => _controller.close();
}
