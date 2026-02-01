import "package:capital_commons/core/logger.dart";
import "package:capital_commons/models/app_user.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthClientException implements Exception {
  const AuthClientException([this.message = "An unexpected error occurred"]);
  final String message;
}

class AuthClient {
  final _auth = FirebaseAuth.instance;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    Log.debug("Signing up for email $email");
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      Log.error(
        "FirebaseAuthException occurred during sign up with email and password: $e",
      );
      throw const AuthClientException(
        "A FirebaseAuthException occurred during sign up",
      );
    }
  }

  Stream<AppUser?> get userChanges {
    final userStream = _auth.userChanges();
    return userStream.map((user) {
      if (user == null) return null;
      return AppUser(uid: user.uid, email: user.email);
    });
  }

  AppUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return AppUser(uid: user.uid, email: user.email);
  }
}
