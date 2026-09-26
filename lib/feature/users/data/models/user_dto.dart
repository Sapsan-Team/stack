// domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
sealed class UserDto with _$UserDto {
  const factory UserDto({
    required String id,

    @JsonKey(name: 'phone_number') required String phoneNumber,

    String? username,

    @JsonKey(name: 'display_name') String? displayName,

    String? bio,

    @JsonKey(name: 'created_at') required DateTime createdAt,

    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}
