import 'package:todo/features/auth/data/models/auth_response_dto.dart';

abstract interface class UserRemoteDataSource {
  Future<AuthResponseDto> fetchUserByPassword(
    String phoneNumber,
    String password,
  );

  Future<AuthResponseDto> register({
    required String phoneNumber,
    required String username,
    required String displayName,
    required String password,
  });
}

