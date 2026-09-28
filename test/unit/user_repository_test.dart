import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/data/datasources/remote/user_remote_data_source.dart';
import 'package:todo/features/auth/data/models/auth_response_dto.dart';
import 'package:todo/features/auth/data/models/user_dto.dart';
import 'package:todo/features/auth/data/repositories/user_repository_impl.dart';

class MockSuccessRemoteDataSource implements UserRemoteDataSource {
  @override
  Future<AuthResponseDto> fetchUserByPassword(
    String phoneNumber,
    String password,
  ) async {
    return const AuthResponseDto(
      token: 'jwt_sample_token',
      user: UserDto(
        id: 'u1',
        phoneNumber: '+79991234567',
        username: 'testuser',
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
    return const AuthResponseDto(
      token: 'jwt_registered_token',
      user: UserDto(
        id: 'u2',
        phoneNumber: '+79997654321',
        username: 'newuser',
        displayName: 'New User',
      ),
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
        data: {'error': 'Неверный телефон или пароль'},
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
        data: {'error': 'Пользователь с таким номером уже зарегистрирован'},
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  group('UserRepositoryImpl with Either', () {
    test('returns Right(User) and saves token on login success', () async {
      final repo = UserRepositoryImpl(
        remote: MockSuccessRemoteDataSource(),
        prefs: prefs,
      );

      final result = await repo.getUser('+79991234567', 'password123');

      expect(result.isRight, isTrue);
      result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (user) {
          expect(user.id, 'u1');
          expect(user.phoneNumber, '+79991234567');
          expect(user.username, 'testuser');
        },
      );
      expect(prefs.getString('auth_token'), 'jwt_sample_token');
    });

    test('returns Left(AuthFailure) on 401 with backend error message', () async {
      final repo = UserRepositoryImpl(
        remote: MockAuthFailureRemoteDataSource(),
        prefs: prefs,
      );

      final result = await repo.getUser('+79991234567', 'wrong_pass');

      expect(result.isLeft, isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Неверный телефон или пароль');
        },
        (user) => fail('Expected Left, got Right: $user'),
      );
    });

    test('returns Right(User) and saves token on register success', () async {
      final repo = UserRepositoryImpl(
        remote: MockSuccessRemoteDataSource(),
        prefs: prefs,
      );

      final result = await repo.register(
        phoneNumber: '+79997654321',
        username: 'newuser',
        displayName: 'New User',
        password: 'password123',
      );

      expect(result.isRight, isTrue);
      result.fold(
        (failure) => fail('Expected Right, got Left: $failure'),
        (user) {
          expect(user.id, 'u2');
          expect(user.phoneNumber, '+79997654321');
          expect(user.username, 'newuser');
          expect(user.displayName, 'New User');
        },
      );
      expect(prefs.getString('auth_token'), 'jwt_registered_token');
    });

    test('returns Left(ServerFailure) on 409 conflict during register', () async {
      final repo = UserRepositoryImpl(
        remote: MockAuthFailureRemoteDataSource(),
        prefs: prefs,
      );

      final result = await repo.register(
        phoneNumber: '+79997654321',
        username: 'newuser',
        displayName: 'New User',
        password: 'password123',
      );

      expect(result.isLeft, isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Пользователь с таким номером уже зарегистрирован');
        },
        (user) => fail('Expected Left, got Right: $user'),
      );
    });
  });
}
