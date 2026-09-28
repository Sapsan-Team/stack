import 'package:either_dart/either.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/domain/entities/user.dart';
import 'package:todo/features/auth/domain/repositories/user_repository.dart';

class RegisterUserUseCase {
  final UserRepository userRepository;

  RegisterUserUseCase({required this.userRepository});

  Future<Either<Failure, User>> execute({
    required String phoneNumber,
    required String username,
    required String displayName,
    required String password,
  }) {
    return userRepository.register(
      phoneNumber: phoneNumber,
      username: username,
      displayName: displayName,
      password: password,
    );
  }
}
