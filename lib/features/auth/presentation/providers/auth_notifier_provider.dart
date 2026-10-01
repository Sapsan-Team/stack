import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/features/auth/presentation/providers/auth_state.dart';
import 'package:todo/features/auth/presentation/providers/auth_notifier.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
