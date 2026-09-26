// data/repositories/user_repository_impl.dart
import 'package:todo/feature/users/domain/entities/repositories/user_remote.dart';
import 'package:todo/feature/users/domain/entities/repositories/user_repository.dart';
import 'package:todo/feature/users/domain/entities/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl({required this.remote});

  @override
  Future<User> getUser(int id) async {
    try {
      final remoteUser = await remote.fetchUser(id);

      return remoteUser;
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}
