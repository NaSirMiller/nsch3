import "package:capital_commons/clients/auth_client.dart";
import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/models/create_business.dart";
import "package:capital_commons/models/user_info.dart";
import "package:capital_commons/repositories/business_repository.dart";
import "package:capital_commons/repositories/user_info_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "business_signup_cubit.freezed.dart";

class BusinessSignupCubit extends Cubit<BusinessSignupState> {
  BusinessSignupCubit() : super(const BusinessSignupState());

  final _authClient = getIt<AuthClient>();
  final _businessRepository = getIt<BusinessRepository>();
  final _userRepository = getIt<UserInfoRepository>();

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

    // TODO: Add profile logo path to the store business info method
    try {
      await _userRepository.saveUserInfo(
        user.uid,
        UserInfo(isSeller: true, profileLogoFilepath: ""),
      );
    } catch (_) {
      Log.error("Could not create user info");
      emit(state.copyWith(message: "Could not create user info"));
      emit(state.copyWith(message: null));
    }
    try {
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
          sharesAvailable: totalShares,
          ticker: businessName.substring(0, 3),
        ),
      );
    } catch (_) {
      Log.error("Could not create business");
      emit(state.copyWith(message: "Could not create business"));
      emit(state.copyWith(message: null));
    }

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
}

@freezed
sealed class BusinessSignupState with _$BusinessSignupState {
  const factory BusinessSignupState({
    @Default(LoadingStatus.initial) LoadingStatus signupStatus,
    @Default(LoadingStatus.initial) LoadingStatus storeBusinessInfoStatus,
    double? valuation,
    String? message,
  }) = _BusinessSignupState;
}
