import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/domain/entities/user.dart';

enum AuthStatus {
  checking,
  authenticated,
  unauthenticated,
  restorationFailed,
}

class AuthState {
  const AuthState._({
    required this.status,
    this.user,
    this.restorationFailure,
  });

  const AuthState.checking() : this._(status: AuthStatus.checking);

  const AuthState.authenticated(User user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  const AuthState.restorationFailed(Failure failure)
    : this._(
        status: AuthStatus.restorationFailed,
        restorationFailure: failure,
      );

  final AuthStatus status;
  final User? user;
  final Failure? restorationFailure;
}
