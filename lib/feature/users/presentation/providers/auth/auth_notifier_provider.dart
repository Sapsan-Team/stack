import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/feature/users/domain/entities/user.dart';
import 'package:todo/feature/users/presentation/providers/auth/auth_notifier.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});
