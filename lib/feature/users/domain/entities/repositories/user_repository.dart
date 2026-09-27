import 'package:todo/feature/users/domain/entities/user.dart';

abstract interface class UserRepository {
  Future<User> getUser(String phoneNumber, String password);
}
