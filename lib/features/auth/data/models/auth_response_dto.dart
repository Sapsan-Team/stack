import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_response_dto.freezed.dart';
part 'auth_response_dto.g.dart';

@freezed
sealed class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required String accessToken,
    required String tokenType,
    required DateTime expiresAt,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);
}
