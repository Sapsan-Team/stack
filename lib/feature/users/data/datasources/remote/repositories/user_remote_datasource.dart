import 'package:dio/dio.dart';
import 'package:todo/feature/users/data/models/auth_response_dto.dart';
import 'package:todo/feature/users/domain/entities/repositories/user_remote.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponseDto> fetchUserByPassword(
    String phoneNumber,
    String password,
  ) async {
    final response = await dio.post(
      '/api/auth/login',
      data: {'phone_number': phoneNumber, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    return AuthResponseDto.fromJson(data);
  }
}

