import 'package:todo/feature/users/domain/entities/repositories/user_repository.dart';
import 'package:todo/feature/users/domain/entities/user.dart';

class LoginUserUseCase {
  final UserRepository userRepository;

  LoginUserUseCase({required this.userRepository});

  Future<User> execute(String phoneNumber, String password) async {
    return await userRepository.getUser(phoneNumber, password);
  }
}

