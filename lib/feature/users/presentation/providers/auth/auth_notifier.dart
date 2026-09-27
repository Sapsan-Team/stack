// feature/users/presentation/providers/auth_notifier.dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/feature/users/domain/entities/user.dart';
import 'package:todo/feature/users/presentation/providers/user_provider.dart';

class AuthNotifier extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  Future<void> login(String phone, String password) async {
    final loginUseCase = ref.read(loginUseCaseProvider);
    final user = await loginUseCase.execute(phone, password);
    state = user;
  }

  void logout() {
    state = null;
  }
}
