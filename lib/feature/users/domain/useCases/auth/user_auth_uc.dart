import 'package:todo/feature/users/data/repositories/user_repositories_impl.dart';
import 'package:todo/feature/users/domain/entities/user.dart';

class LoginUserUseCase {
  final UserRepositoryImpl userRepository;

  LoginUserUseCase({required this.userRepository});

  Future<User> execute(String phoneNumber, String password) async {
    return await userRepository.getUser(phoneNumber, password);
  }
}
