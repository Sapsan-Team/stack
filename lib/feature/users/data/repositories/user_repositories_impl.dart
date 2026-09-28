import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/feature/users/data/models/user_dto.dart';
import 'package:todo/feature/users/domain/entities/repositories/user_remote.dart';
import 'package:todo/feature/users/domain/entities/repositories/user_repository.dart';
import 'package:todo/feature/users/domain/entities/user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;
  final SharedPreferences prefs;

  static const String tokenKey = 'auth_token';

  UserRepositoryImpl({required this.remote, required this.prefs});

  @override
  Future<User> getUser(String phoneNumber, String password) async {
    try {
      final authResponse = await remote.fetchUserByPassword(
        phoneNumber,
        password,
      );
      await prefs.setString(tokenKey, authResponse.token);
      return authResponse.user.toDomain();
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }
}

