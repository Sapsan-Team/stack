// import 'package:dio/dio.dart';
// import 'package:todo/feature/users/domain/entities/repositories/user_remote.dart';
// import 'package:todo/feature/users/domain/entities/user.dart';

// class UserRemoteDataSourceImpl implements UserRemoteDataSource {
//   final Dio dio;
//   UserRemoteDataSourceImpl(this.dio);

//   @override
//   Future<User> fetchUser(int id) async {
//     final response = await dio.get('/users/$id');
//     // В реальном проекте здесь используется UserDto.fromJson(response.data)
//     return User(id: response.data['id'], name: response.data['name']);
//   }
// }
//TODO
