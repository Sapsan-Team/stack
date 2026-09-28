import 'package:either_dart/either.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/error/failure.dart';
import 'package:todo/feature/users/domain/entities/user.dart';
import 'package:todo/feature/users/presentation/providers/user_provider.dart';

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

  void logout() {
    state = null;
  }
}

