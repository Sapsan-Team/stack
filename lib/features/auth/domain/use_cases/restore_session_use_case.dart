import 'package:either_dart/either.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/domain/entities/user.dart';
import 'package:todo/features/auth/domain/repositories/user_repository.dart';

class RestoreSessionUseCase {
  const RestoreSessionUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  final UserRepository _userRepository;

  Future<Either<Failure, User?>> execute() => _userRepository.restoreSession();
}
