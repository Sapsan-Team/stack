abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Ошибка сервера']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Ошибка сети или соединения']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Неверный номер телефона или пароль']);
}
