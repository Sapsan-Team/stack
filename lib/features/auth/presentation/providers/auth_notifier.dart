import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/core/providers/auth_session_events_provider.dart';
import 'package:todo/features/auth/domain/entities/user.dart';
import 'package:todo/features/auth/presentation/providers/auth_provider.dart';
import 'package:todo/features/auth/presentation/providers/auth_state.dart';

class AuthNotifier extends Notifier<AuthState> {
  Future<void>? _restoreSessionFuture;

  @override
  AuthState build() {
    final subscription = ref
        .read(authSessionEventsProvider)
        .expired
        .listen((_) => state = const AuthState.unauthenticated());
    ref.onDispose(() => unawaited(subscription.cancel()));
    return const AuthState.checking();
  }

  Future<void> restoreSession() {
    if (state.status != AuthStatus.checking) {
      return Future<void>.value();
    }
    return _restoreSessionFuture ??= _restoreSession();
  }

  Future<void> _restoreSession() async {
    try {
      final result = await ref.read(restoreSessionUseCaseProvider).execute();
      result.fold(
        (failure) => state = AuthState.restorationFailed(failure),
        (user) => state = user == null
            ? const AuthState.unauthenticated()
            : AuthState.authenticated(user),
      );
    } finally {
      _restoreSessionFuture = null;
    }
  }

  Future<void> retrySessionRestoration() async {
    state = const AuthState.checking();
    await restoreSession();
  }

  Future<Either<Failure, User>> login(String phone, String password) async {
    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase.execute(phone, password);

    result.fold(
      (failure) {},
      (user) => state = AuthState.authenticated(user),
    );

    return result;
  }

  Future<Either<Failure, User>> register({
    required String phone,
    required String username,
    required String displayName,
    required String password,
  }) async {
    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase.execute(
      phoneNumber: phone,
      username: username,
      displayName: displayName,
      password: password,
    );

    result.fold(
      (failure) {},
      (user) => state = AuthState.authenticated(user),
    );

    return result;
  }

  Future<void> logout() async {
    await ref.read(logoutUseCaseProvider).execute();
    state = const AuthState.unauthenticated();
  }
}
