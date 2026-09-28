import 'package:either_dart/either.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/domain/repositories/user_repository.dart';
import 'package:todo/features/auth/domain/entities/user.dart';

class LoginUserUseCase {
  final UserRepository userRepository;

  LoginUserUseCase({required this.userRepository});

  Future<Either<Failure, User>> execute(
    String phoneNumber,
    String password,
  ) {
    return userRepository.getUser(phoneNumber, password);
  }
}


