import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/data/datasources/remote/user_remote_data_source.dart';
import 'package:todo/features/auth/data/models/auth_response_dto.dart';
import 'package:todo/features/auth/data/token_storage/auth_token_storage.dart';
import 'package:todo/features/auth/data/models/user_dto.dart';
import 'package:todo/features/auth/data/repositories/user_repository_impl.dart';

class _MemoryAuthTokenStorage implements AuthTokenStorage {
  String? token;

  @override
  Future<String?> read() async => token;

  @override
  Future<void> write(String token) async {
    this.token = token;
  }

  @override
  Future<void> delete() async {
    token = null;
  }
}

class MockSuccessRemoteDataSource implements UserRemoteDataSource {
  MockSuccessRemoteDataSource({this.rejectCurrentUser = false});

  final bool rejectCurrentUser;

  @override
  Future<AuthResponseDto> fetchUserByPassword(
    String phoneNumber,
    String password,
  ) async {
    return AuthResponseDto(
      accessToken: 'jwt_sample_token',
      tokenType: 'Bearer',
      expiresAt: DateTime.utc(2026, 10, 1),
    );
  }

  @override
  Future<AuthResponseDto> register({
    required String phoneNumber,
    required String username,
    required String displayName,
    required String password,
  }) async {
    return AuthResponseDto(
      accessToken: 'jwt_registered_token',
      tokenType: 'Bearer',
      expiresAt: DateTime.utc(2026, 10, 1),
    );
  }

  @override
  Future<UserDto> fetchCurrentUser(String accessToken) async {
    if (rejectCurrentUser) {
      throw DioException(
        requestOptions: RequestOptions(path: '/api/auth/me'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/auth/me'),
          statusCode: 401,
          data: {'title': 'Unauthorized', 'status': 401},
        ),
      );
    }

    return accessToken == 'jwt_sample_token'
        ? const UserDto(
            id: 'u1',
            phoneNumber: '+79991234567',
            username: 'testuser',
          )
        : const UserDto(
            id: 'u2',
            phoneNumber: '+79997654321',
            username: 'newuser',
            displayName: 'New User',
          );
  }
}

class MockAuthFailureRemoteDataSource implements UserRemoteDataSource {
  @override
  Future<AuthResponseDto> fetchUserByPassword(
    String phoneNumber,
    String password,
  ) async {
    throw DioException(
      requestOptions: RequestOptions(path: '/api/auth/login'),
      response: Response(
        requestOptions: RequestOptions(path: '/api/auth/login'),
        statusCode: 401,
        data: {'title': 'Unauthorized', 'status': 401},
      ),
    );
  }

  @override
  Future<AuthResponseDto> register({
    required String phoneNumber,
    required String username,
    required String displayName,
    required String password,
  }) async {
    throw DioException(
      requestOptions: RequestOptions(path: '/api/auth/register'),
      response: Response(
        requestOptions: RequestOptions(path: '/api/auth/register'),
        statusCode: 409,
        data: {
          'title': 'Account already exists',
          'detail': 'The phone number or username is already registered.',
          'status': 409,
        },
      ),
    );
  }

  @override
  Future<UserDto> fetchCurrentUser(String accessToken) async {
    throw UnimplementedError();
  }
}

void main() {
  late _MemoryAuthTokenStorage tokenStorage;

  setUp(() async {
    tokenStorage = _MemoryAuthTokenStorage();
  });

  group('UserRepositoryImpl with Either', () {
    test('returns Right(User) and saves token on login success', () async {
      final repo = UserRepositoryImpl(
        remote: MockSuccessRemoteDataSource(),
        tokenStorage: tokenStorage,
      );

      final result = await repo.getUser('+79991234567', 'password123');

      expect(result.isRight, isTrue);
      result.fold((failure) => fail('Expected Right, got Left: $failure'), (
        user,
      ) {
        expect(user.id, 'u1');
        expect(user.phoneNumber, '+79991234567');
        expect(user.username, 'testuser');
      });
      expect(tokenStorage.token, 'jwt_sample_token');
    });

    test('returns Left(AuthFailure) on 401 without a generic title', () async {
      final repo = UserRepositoryImpl(
        remote: MockAuthFailureRemoteDataSource(),
        tokenStorage: tokenStorage,
      );

      final result = await repo.getUser('+79991234567', 'wrong_pass');

      expect(result.isLeft, isTrue);
      result.fold((failure) {
        expect(failure, isA<AuthFailure>());
        expect(failure.message, isNull);
      }, (user) => fail('Expected Left, got Right: $user'));
    });

    test('returns Right(User) and saves token on register success', () async {
      final repo = UserRepositoryImpl(
        remote: MockSuccessRemoteDataSource(),
        tokenStorage: tokenStorage,
      );

      final result = await repo.register(
        phoneNumber: '+79997654321',
        username: 'newuser',
        displayName: 'New User',
        password: 'password123',
      );

      expect(result.isRight, isTrue);
      result.fold((failure) => fail('Expected Right, got Left: $failure'), (
        user,
      ) {
        expect(user.id, 'u2');
        expect(user.phoneNumber, '+79997654321');
        expect(user.username, 'newuser');
        expect(user.displayName, 'New User');
      });
      expect(tokenStorage.token, 'jwt_registered_token');
    });

    test(
      'returns Left(ServerFailure) on 409 conflict during register',
      () async {
        final repo = UserRepositoryImpl(
          remote: MockAuthFailureRemoteDataSource(),
          tokenStorage: tokenStorage,
        );

        final result = await repo.register(
          phoneNumber: '+79997654321',
          username: 'newuser',
          displayName: 'New User',
          password: 'password123',
        );

        expect(result.isLeft, isTrue);
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          expect(
            failure.message,
            'The phone number or username is already registered.',
          );
        }, (user) => fail('Expected Left, got Right: $user'));
      },
    );

    test('clears a stored token when the API rejects the restored session', () async {
      tokenStorage.token = 'expired-token';
      final repo = UserRepositoryImpl(
        remote: MockSuccessRemoteDataSource(rejectCurrentUser: true),
        tokenStorage: tokenStorage,
      );

      final result = await repo.restoreSession();

      expect(result.isRight, isTrue);
      result.fold(
        (failure) => fail('Expected expired session to be cleared: $failure'),
        (user) => expect(user, isNull),
      );
      expect(tokenStorage.token, isNull);
    });
  });
}
