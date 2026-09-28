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
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  group('UserRepositoryImpl with Either', () {
    test('returns Right(User) and saves token on success', () async {
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
  });
}
