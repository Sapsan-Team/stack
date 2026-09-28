import 'package:flutter_test/flutter_test.dart';
import 'package:todo/feature/users/data/models/auth_response_dto.dart';
import 'package:todo/feature/users/data/models/user_dto.dart';

void main() {
  group('AuthResponseDto', () {
    test('successfully parses JSON matching Go backend response', () {
      final json = {
        'token': 'jwt_token_sample',
        'user': {
          'id': 'u123',
          'phone_number': '+79991234567',
          'username': 'john_doe',
          'display_name': 'John Doe',
        },
      };

      final authResponse = AuthResponseDto.fromJson(json);

      expect(authResponse.token, 'jwt_token_sample');
      expect(authResponse.user.id, 'u123');
      expect(authResponse.user.phoneNumber, '+79991234567');
      expect(authResponse.user.username, 'john_doe');
      expect(authResponse.user.displayName, 'John Doe');

      final user = authResponse.user.toDomain();
      expect(user.id, 'u123');
      expect(user.phoneNumber, '+79991234567');
      expect(user.username, 'john_doe');
      expect(user.displayName, 'John Doe');
    });
  });
}
