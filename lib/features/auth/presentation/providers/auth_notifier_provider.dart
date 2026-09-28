import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/features/auth/domain/entities/user.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, User?>(() {
  return AuthNotifier();
});
