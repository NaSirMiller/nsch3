import "package:capital_commons/core/logger.dart";
import "package:capital_commons/models/user_info.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class UserInfoRepositoryException implements Exception {
  const UserInfoRepositoryException([
    this.message = "An unexpected error occurred",
  ]);
  final String message;
}

class UserInfoRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveUserInfo(String userId, UserInfo userInfo) async {
    try {
      await _firestore
          .collection("userInfo")
          .doc(userId)
          .set(userInfo.toJson());
    } on FirebaseException catch (e) {
      Log.error(
        "FirebaseException occurred while creating user info for $userId: $e",
      );
      throw const UserInfoRepositoryException("A FirebaseException occurred");
    }
  }

  Future<UserInfo?> getUserInfo(String userId) async {
    try {
      final doc = await _firestore.collection("userInfo").doc(userId).get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserInfo.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      Log.error(
        "FirebaseException occurred while fetching user info for $userId: $e",
      );
      throw const UserInfoRepositoryException("A FirebaseException occurred");
    } on UserInfoRepositoryException {
      rethrow;
    } catch (e) {
      Log.error(
        "Unknown error occurred while fetching user info for $userId: $e",
      );
      throw const UserInfoRepositoryException();
    }
  }
}
