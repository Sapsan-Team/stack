import 'package:dio/dio.dart';
import 'package:todo/features/auth/data/models/auth_response_dto.dart';
import 'package:todo/features/auth/data/models/user_dto.dart';
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
      data: {'phoneNumber': phoneNumber, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    return AuthResponseDto.fromJson(data);
  }

  @override
  Future<AuthResponseDto> register({
    required String phoneNumber,
    required String username,
    required String displayName,
    required String password,
  }) async {
    final response = await dio.post(
      '/api/auth/register',
      data: {
        'phoneNumber': phoneNumber,
        'username': username,
        'displayName': displayName,
        'password': password,
      },
    );
    final data = response.data as Map<String, dynamic>;
    return AuthResponseDto.fromJson(data);
  }

  @override
  Future<UserDto> fetchCurrentUser(String accessToken) async {
    final response = await dio.get(
      '/api/auth/me',
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    final data = response.data as Map<String, dynamic>;
    return UserDto.fromJson(data);
  }
}
