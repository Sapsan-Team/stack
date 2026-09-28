import 'package:todo/features/auth/data/models/auth_response_dto.dart';

abstract interface class UserRemoteDataSource {
  Future<AuthResponseDto> fetchUserByPassword(String phoneNumber, String password);
}

