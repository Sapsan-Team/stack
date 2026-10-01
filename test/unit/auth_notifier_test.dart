import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/core/providers/auth_session_events_provider.dart';
import 'package:todo/features/auth/domain/entities/user.dart';
import 'package:todo/features/auth/domain/repositories/user_repository.dart';
import 'package:todo/features/auth/domain/services/auth_session_events.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier_provider.dart';
import 'package:todo/features/auth/presentation/providers/auth_provider.dart';
import 'package:todo/features/auth/presentation/providers/auth_state.dart';

class _RetryableUserRepository implements UserRepository {
  bool shouldFail = true;

  static const user = User(id: 'user-id', phoneNumber: '+77775556677');

  @override
  Future<Either<Failure, User?>> restoreSession() async {
    if (shouldFail) {
      return Left(NetworkFailure('API unavailable'));
    }
    return const Right(user);
  }

  @override
  Future<Either<Failure, User>> getUser(
    String phoneNumber,
    String password,
  ) async => const Right(user);

  @override
  Future<Either<Failure, User>> register({
    required String phoneNumber,
    required String username,
    required String displayName,
    required String password,
  }) async => const Right(user);

  @override
  Future<void> logout() async {}
}

void main() {
  test('allows retry after a transient session restore failure', () async {
    final repository = _RetryableUserRepository();
    final container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    final notifier = container.read(authNotifierProvider.notifier);
    await notifier.restoreSession();

    expect(
      container.read(authNotifierProvider).status,
      AuthStatus.restorationFailed,
    );
    expect(
      container.read(authNotifierProvider).restorationFailure,
      isA<NetworkFailure>(),
    );

    repository.shouldFail = false;
    await notifier.retrySessionRestoration();

    expect(
      container.read(authNotifierProvider).status,
      AuthStatus.authenticated,
    );
    expect(
      container.read(authNotifierProvider).user,
      _RetryableUserRepository.user,
    );
  });

  test(
    'marks the session unauthenticated when an access token expires',
    () async {
      final repository = _RetryableUserRepository()..shouldFail = false;
      final events = AuthSessionEventBus();
      final container = ProviderContainer(
        overrides: [
          userRepositoryProvider.overrideWithValue(repository),
          authSessionEventsProvider.overrideWithValue(events),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(events.dispose);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.restoreSession();
      expect(
        container.read(authNotifierProvider).status,
        AuthStatus.authenticated,
      );

      events.notifyExpired();

      expect(
        container.read(authNotifierProvider).status,
        AuthStatus.unauthenticated,
      );
      expect(container.read(authNotifierProvider).user, isNull);
    },
  );
}
