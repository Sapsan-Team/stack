import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/data/datasources/remote/user_remote_data_source.dart';
import 'package:todo/features/auth/data/models/user_dto.dart';
import 'package:todo/features/auth/domain/repositories/user_repository.dart';
import 'package:todo/features/auth/domain/entities/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final SharedPreferences prefs;

  static const String tokenKey = 'auth_token';

  UserRepositoryImpl({required this.remote, required this.prefs});

  @override
  Future<Either<Failure, User>> getUser(
    String phoneNumber,
    String password,
  ) async {
    try {
      final authResponse = await remote.fetchUserByPassword(
        phoneNumber,
        password,
      );
      await prefs.setString(tokenKey, authResponse.token);
      return Right(authResponse.user.toDomain());
    } on DioException catch (e) {
      final data = e.response?.data;
      String? errorMsg;
      if (data is Map && data['error'] is String) {
        errorMsg = data['error'] as String;
      }

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return Left(NetworkFailure(errorMsg));
      }

      if (e.response?.statusCode == 401) {
        return Left(AuthFailure(errorMsg));
      }

      return Left(ServerFailure(errorMsg ?? e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


