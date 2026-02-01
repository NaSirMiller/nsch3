import "dart:io";
import "dart:typed_data";

import "package:capital_commons/clients/auth_client.dart";
import "package:capital_commons/clients/file_storage_client.dart";
import "package:capital_commons/clients/pl_processing_client.dart";
import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/models/create_business.dart";
import "package:capital_commons/models/pl_processing_result.dart";
import "package:capital_commons/repositories/business_repository.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:uuid/uuid.dart";

part "business_signup_cubit.freezed.dart";

class BusinessSignupCubit extends Cubit<BusinessSignupState> {
  BusinessSignupCubit() : super(const BusinessSignupState());

  final _authClient = getIt<AuthClient>();
  final _businessRepository = getIt<BusinessRepository>();
  final _fileStorageClient = getIt<FileStorageClient>();
  final _plProcessingClient = getIt<PlProcessingClient>();

  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(signupStatus: LoadingStatus.loading));
    try {
      await _authClient.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(signupStatus: LoadingStatus.success));
    } on AuthClientException catch (e) {
      Log.error(
        "AuthClientException occurred while signing up with email and password: $e",
      );
      emit(
        state.copyWith(
          signupStatus: LoadingStatus.failure,
          message: "An error occurred while signing up",
        ),
      );
      emit(state.copyWith(message: null));
    }
  }

  Future<void> storeBusinessInfo({
    required String businessName,
    required String address,
    required String year,
    required String selectedType,
    required double revenue,
    required double expenses,
    required double netProfit,
    required int totalShares,
    required double pricePerShare,
    required double dividend,
  }) async {
    emit(state.copyWith(storeBusinessInfoStatus: LoadingStatus.loading));

    final user = _authClient.currentUser1;

    if (user == null) {
      emit(
        state.copyWith(
          storeBusinessInfoStatus: LoadingStatus.failure,
          message: "User is not signed in",
        ),
      );
      emit(state.copyWith(message: null));
      return;
    }

    await _businessRepository.createBusiness(
      CreateBusiness(
        uid: user.uid,
        name: businessName,
        description: "",
        industry: "",
        logoFilepath: "",
        plDocFilepath: "",
        projectedRevenue: revenue,
        projectedExpenses: expenses,
        projectedProfit: revenue - expenses,
        valuation: state.valuation ?? 1.0,
        totalSharesIssued: 0,
        sharePrice: pricePerShare,
        dividendPercentage: dividend,
        isApproved: false,
        address: address,
        amountRaised: 0,
        numInvestors: 0,
        goal: -1, // TODO: Get from eval results
        yearFounded: year,
      ),
    );

    emit(state.copyWith(storeBusinessInfoStatus: LoadingStatus.success));
  }

  Future<void> submitForm({
    required String email,
    required String password,
    required String businessName,
    required String address,
    required String year,
    required String? selectedType,
    required String revenue,
    required String expenses,
    required String netProfit,
    required String? selectedPeriod,
    required String totalShares,
    required String pricePerShare,
    required String dividend,
    required bool agreedToTerms,
  }) async {
    if (selectedType == null || selectedPeriod == null || !agreedToTerms) {
      Log.error("Missing required field(s)");
      emit(state.copyWith(message: "Missing required field(s)"));
      emit(state.copyWith(message: null));
      return;
    }

    await signUpWithEmail(email: email, password: password);

    try {
      await storeBusinessInfo(
        businessName: businessName,
        address: address,
        year: year,
        selectedType: selectedType,
        revenue: double.parse(revenue),
        expenses: double.parse(expenses),
        totalShares: int.parse(totalShares),
        pricePerShare: double.parse(pricePerShare),
        dividend: double.parse(dividend),
        netProfit: double.parse(netProfit),
      );
    } catch (_) {
      Log.error("Invalid input data");
      emit(state.copyWith(message: "Invalid input data"));
      emit(state.copyWith(message: null));
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["pdf"],
    );
    if (result != null && result.files.isNotEmpty) {
      final fileBytes = result.files.first.bytes;
      final fileName = result.files.first.name;

      // Emit both file bytes and a temporary filePath for UI
      emit(
        state.copyWith(
          plFileBytes: fileBytes,
          plFilePath: fileName, // just the filename for immediate display
        ),
      );
      Log.info("File picked: $fileName");
    } else {
      Log.debug("User closed file picker");
    }
  }

  Future<void> uploadAndProcessPlFile() async {
    final fileBytes = state.plFileBytes;

    if (fileBytes == null) {
      Log.warning("No P&L file selected by user.");
      emit(
        state.copyWith(
          uploadAndProcessPlFileStatus: LoadingStatus.failure,
          message: "No file selected",
        ),
      );
      emit(state.copyWith(message: null));
      return;
    }

    // Generate UUID for filename
    final uuid = const Uuid().v4();
    final fileName = "$uuid.pdf"; // force PDF extension
    const folder = "business/temp_pl_documents"; // pre-signup folder

    Log.info("Starting P&L upload process. Generated file name: $fileName");
    emit(state.copyWith(uploadAndProcessPlFileStatus: LoadingStatus.loading));

    try {
      // 1️⃣ Upload the bytes
      final uploadedPath = await _fileStorageClient.uploadBytes(
        bytes: fileBytes,
        folder: folder,
        fileName: fileName,
      );
      Log.info("File uploaded successfully. Storage path: $uploadedPath");

      // 2️⃣ Process via Cloud Function
      final processingResult = await _plProcessingClient.processPlFile(
        uploadedPath,
      );
      Log.info(
        "P&L processed successfully: "
        "Total Revenue=${processingResult.totalRevenue}, "
        "Total Expenses=${processingResult.totalExpenses}",
      );

      // 3️⃣ Update state
      emit(
        state.copyWith(
          uploadAndProcessPlFileStatus: LoadingStatus.success,
          plFilePath: uploadedPath,
          plProcessingResult: processingResult,
        ),
      );
      Log.info("State updated with uploaded file and processing result.");
    } on FileStorageClientException catch (e) {
      Log.error("PL upload failed: ${e.message}");
      emit(
        state.copyWith(
          uploadAndProcessPlFileStatus: LoadingStatus.failure,
          message: e.message,
        ),
      );
      emit(state.copyWith(message: null));
    } on PlProcessingClientException catch (e) {
      Log.error("PL processing failed: ${e.message}");
      emit(
        state.copyWith(
          uploadAndProcessPlFileStatus: LoadingStatus.failure,
          message: e.message,
        ),
      );
      emit(state.copyWith(message: null));
    } catch (e, stack) {
      Log.error("Unexpected error during PL upload and processing: $e\n$stack");
      emit(
        state.copyWith(
          uploadAndProcessPlFileStatus: LoadingStatus.failure,
          message: "Failed to upload and process P&L",
        ),
      );
      emit(state.copyWith(message: null));
    }
  }

  void removePlFile() {
    emit(state.copyWith(plFileBytes: null, plFilePath: null));
  }
}

@freezed
sealed class BusinessSignupState with _$BusinessSignupState {
  const factory BusinessSignupState({
    @Default(LoadingStatus.initial) LoadingStatus signupStatus,
    @Default(LoadingStatus.initial) LoadingStatus storeBusinessInfoStatus,
    @Default(LoadingStatus.initial) LoadingStatus uploadAndProcessPlFileStatus,

    Uint8List? plFileBytes,

    PlProcessingResult? plProcessingResult,
    String? plFilePath,

    double? valuation,
    String? message,
  }) = _BusinessSignupState;
}
