import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/core/providers/dio_provider.dart';
import 'package:todo/core/providers/shared_preferences_provider.dart';
import 'package:todo/feature/users/data/datasources/remote/repositories/user_remote_datasource.dart';
import 'package:todo/feature/users/data/repositories/user_repositories_impl.dart';
import 'package:todo/feature/users/domain/entities/repositories/user_remote.dart';
import 'package:todo/feature/users/domain/entities/repositories/user_repository.dart';
import 'package:todo/feature/users/domain/useCases/auth/user_auth_uc.dart';

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

// 3. Use Case
final loginUseCaseProvider = Provider<LoginUserUseCase>((ref) {
  return LoginUserUseCase(userRepository: ref.watch(userRepositoryProvider));
});

