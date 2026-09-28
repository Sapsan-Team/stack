import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo/feature/users/domain/entities/user.dart';

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

    @JsonKey(name: 'created_at') DateTime? createdAt,

    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

extension UserDtoX on UserDto {
  User toDomain() => User(
        id: id,
        phoneNumber: phoneNumber,
        username: username,
        displayName: displayName,
        bio: bio,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
