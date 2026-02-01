import "package:capital_commons/clients/auth_client.dart";
import "package:capital_commons/clients/exchange_client.dart";
import "package:capital_commons/clients/file_storage_client.dart";
import "package:capital_commons/clients/pl_processing_client.dart";
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/features/user/user_cubit.dart";
import "package:capital_commons/firebase_options.dart";
import "package:capital_commons/repositories/business_repository.dart";
import "package:capital_commons/repositories/holdings_repository.dart";
import "package:capital_commons/repositories/transaction_repository.dart";
import "package:capital_commons/repositories/user_info_repository.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:cloud_functions/cloud_functions.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator("localhost", 8080);
      await FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
      FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
      await FirebaseStorage.instance.useStorageEmulator("localhost", 9199);
    } catch (e) {
      Log.fatal(e);
    }
  }

  // Register clients
  getIt.registerLazySingleton(() => AuthClient());
  getIt.registerLazySingleton(() => ExchangeClient());
  getIt.registerLazySingleton(() => FileStorageClient());
  getIt.registerLazySingleton(() => PlProcessingClient());

  // Register repositories
  getIt.registerLazySingleton(() => BusinessRepository());
  getIt.registerLazySingleton(() => UserInfoRepository());
  getIt.registerLazySingleton(() => HoldingsRepository());
  getIt.registerLazySingleton(() => TransactionRepository());

  // Register UserCubit as singleton
  getIt.registerLazySingleton(() => UserCubit());
}
