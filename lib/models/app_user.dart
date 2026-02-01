import "package:freezed_annotation/freezed_annotation.dart";
import "package:capital_commons/models/user_info.dart";

part "app_user.freezed.dart";
part "app_user.g.dart";

@freezed
sealed class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    String? email,
    UserInfo? userInfo,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
