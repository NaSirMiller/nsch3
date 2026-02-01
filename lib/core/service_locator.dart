import "package:capital_commons/clients/auth_client.dart";
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/features/user/user_cubit.dart";
import "package:capital_commons/firebase_options.dart";
import "package:capital_commons/repositories/business_repository.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
      await FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
      // FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
      // await FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
    } catch (e) {
      Log.fatal(e);
    }
  }

  // Register clients
  getIt.registerLazySingleton(() => AuthClient());

  // Register repositories
  getIt.registerLazySingleton(() => BusinessRepository());

  // Register UserCubit as singleton
  getIt.registerLazySingleton(() => UserCubit());
}
