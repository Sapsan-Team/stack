import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo/features/auth/data/models/user_dto.dart';

part 'auth_response_dto.freezed.dart';
part 'auth_response_dto.g.dart';

@freezed
sealed class AuthResponseDto with _$AuthResponseDto {
  const factory AuthResponseDto({
    required String token,
    required UserDto user,
  }) = _AuthResponseDto;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDtoFromJson(json);
}
