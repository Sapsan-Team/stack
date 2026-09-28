import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/features/auth/domain/entities/user.dart';
import 'package:todo/features/auth/presentation/providers/auth_provider.dart';

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  Future<Either<Failure, User>> login(String phone, String password) async {
    final loginUseCase = ref.read(loginUseCaseProvider);
    final result = await loginUseCase.execute(phone, password);

    result.fold(
      (failure) {},
      (user) => state = user,
    );

    return result;
  }

  Future<Either<Failure, User>> register({
    required String phone,
    required String username,
    required String displayName,
    required String password,
  }) async {
    final registerUseCase = ref.read(registerUseCaseProvider);
    final result = await registerUseCase.execute(
      phoneNumber: phone,
      username: username,
      displayName: displayName,
      password: password,
    );

    result.fold(
      (failure) {},
      (user) => state = user,
    );

    return result;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    state = null;
  }
}

