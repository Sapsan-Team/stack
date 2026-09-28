import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/dio_provider.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';
import 'package:todo/features/auth/data/datasources/remote/user_remote_data_source.dart';
import 'package:todo/features/auth/data/datasources/remote/user_remote_data_source_impl.dart';
import 'package:todo/features/auth/data/repositories/user_repository_impl.dart';
import 'package:todo/features/auth/domain/repositories/user_repository.dart';
import 'package:todo/features/auth/domain/use_cases/login_user_use_case.dart';
import 'package:todo/features/auth/domain/use_cases/register_user_use_case.dart';

// 1. Remote Data Source
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSourceImpl(ref.watch(dioProvider));
});

// 2. Repository (возвращает чистый интерфейс UserRepository)
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    remote: ref.watch(userRemoteDataSourceProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

// 3. Use Cases
final loginUseCaseProvider = Provider<LoginUserUseCase>((ref) {
  return LoginUserUseCase(userRepository: ref.watch(userRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUserUseCase>((ref) {
  return RegisterUserUseCase(userRepository: ref.watch(userRepositoryProvider));
});
