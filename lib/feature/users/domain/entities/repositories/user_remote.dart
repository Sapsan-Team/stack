import 'package:todo/feature/users/domain/entities/user.dart';

abstract interface class UserRemoteDataSource {
  Future<User> fetchUserByPassword(String phoneNumber, String password);
}
