import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todo/features/auth/domain/entities/user.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
sealed class UserDto with _$UserDto {
  const factory UserDto({
    required String id,

    required String phoneNumber,

    String? username,

    String? displayName,

    String? bio,

    DateTime? createdAt,

    DateTime? updatedAt,
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
