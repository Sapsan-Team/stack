import 'package:todo/feature/users/data/models/auth_response_dto.dart';

abstract interface class UserRemoteDataSource {
  Future<AuthResponseDto> fetchUserByPassword(String phoneNumber, String password);
}

