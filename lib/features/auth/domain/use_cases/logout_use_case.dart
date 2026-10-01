import 'package:todo/features/auth/domain/repositories/user_repository.dart';

class LogoutUseCase {
  const LogoutUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  final UserRepository _userRepository;

  Future<void> execute() => _userRepository.logout();
}
