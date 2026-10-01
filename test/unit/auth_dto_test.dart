import 'package:flutter_test/flutter_test.dart';
import 'package:todo/features/auth/data/models/auth_response_dto.dart';
import 'package:todo/features/auth/data/models/user_dto.dart';

void main() {
  group('AuthResponseDto', () {
    test('parses the token response returned by the ASP.NET API', () {
      final json = {
        'accessToken': 'jwt_token_sample',
        'tokenType': 'Bearer',
        'expiresAt': '2026-10-01T12:00:00+00:00',
      };

      final authResponse = AuthResponseDto.fromJson(json);

      expect(authResponse.accessToken, 'jwt_token_sample');
      expect(authResponse.tokenType, 'Bearer');
      expect(authResponse.expiresAt, DateTime.parse('2026-10-01T12:00:00+00:00'));
    });

    test('parses the current-user response returned by /api/auth/me', () {
      final user = UserDto.fromJson({
        'id': 'u123',
        'phoneNumber': '+79991234567',
        'username': 'alice',
        'displayName': 'Alice Smith',
      }).toDomain();

      expect(user.id, 'u123');
      expect(user.phoneNumber, '+79991234567');
      expect(user.username, 'alice');
      expect(user.displayName, 'Alice Smith');
    });
  });
}
