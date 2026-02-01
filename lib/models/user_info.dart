import "package:freezed_annotation/freezed_annotation.dart";

part "user_info.freezed.dart";
part "user_info.g.dart";

@freezed
sealed class UserInfo with _$UserInfo {
  factory UserInfo({
    required bool isSeller,
    required String? profileLogoFilepath,
  }) = _UserInfo;
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}
