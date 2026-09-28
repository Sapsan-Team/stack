import 'package:dio/dio.dart';
import 'package:todo/features/auth/data/models/auth_response_dto.dart';
import 'package:todo/features/auth/data/datasources/remote/user_remote_data_source.dart';

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

