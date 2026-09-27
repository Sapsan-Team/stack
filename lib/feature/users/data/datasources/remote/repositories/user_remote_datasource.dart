import 'package:dio/dio.dart';
import 'package:todo/feature/users/data/models/user_dto.dart';
import 'package:todo/feature/users/domain/entities/repositories/user_remote.dart';
import 'package:todo/feature/users/domain/entities/user.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;
  UserRemoteDataSourceImpl(this.dio);

  @override
  Future<User> fetchUserByPassword(String phoneNumber, String password) async {
    final response = await dio.post(
      '/api/users/login',
      data: {'phone_number': phoneNumber, 'password': password},
    );
    return UserDto.fromJson(response.data) as User;
  }
}
