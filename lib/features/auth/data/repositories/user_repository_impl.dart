import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/data/datasources/remote/user_remote_data_source.dart';
import 'package:todo/features/auth/data/models/user_dto.dart';
import 'package:todo/features/auth/data/token_storage/auth_token_storage.dart';
import 'package:todo/features/auth/domain/repositories/user_repository.dart';
import 'package:todo/features/auth/domain/entities/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final AuthTokenStorage tokenStorage;

  UserRepositoryImpl({required this.remote, required this.tokenStorage});

  @override
  Future<Either<Failure, User?>> restoreSession() async {
    try {
      final token = await tokenStorage.read();
      if (token == null || token.isEmpty) {
        return const Right(null);
      }

      final user = await remote.fetchCurrentUser(token);
      return Right(user.toDomain());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await tokenStorage.delete();
        return const Right(null);
      }
      return Left(_failureFromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(
    String phoneNumber,
    String password,
  ) async {
    try {
      final tokenResponse = await remote.fetchUserByPassword(
        phoneNumber,
        password,
      );
      final user = await remote.fetchCurrentUser(tokenResponse.accessToken);
      await tokenStorage.write(tokenResponse.accessToken);
      return Right(user.toDomain());
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String phoneNumber,
    required String username,
    required String displayName,
    required String password,
  }) async {
    try {
      final tokenResponse = await remote.register(
        phoneNumber: phoneNumber,
        username: username,
        displayName: displayName,
        password: password,
      );
      final user = await remote.fetchCurrentUser(tokenResponse.accessToken);
      await tokenStorage.write(tokenResponse.accessToken);
      return Right(user.toDomain());
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() => tokenStorage.delete();

  Left<Failure, User> _handleDioException(DioException e) {
    final failure = _failureFromDioException(e);
    return Left(failure);
  }

  Failure _failureFromDioException(DioException e) {
    final data = e.response?.data;
    String? errorMsg;
    if (data is Map) {
      errorMsg = switch (data) {
        {'detail': final String detail} when detail.isNotEmpty => detail,
        {'error': final String error} when error.isNotEmpty => error,
        {'status': 401} => null,
        {'title': final String title} when title.isNotEmpty => title,
        _ => null,
      };
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkFailure(errorMsg);
    }

    if (e.response?.statusCode == 401) {
      return AuthFailure(errorMsg);
    }

    return ServerFailure(errorMsg ?? e.message);
  }
}
