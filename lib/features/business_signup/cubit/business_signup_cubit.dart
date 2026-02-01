import "package:capital_commons/clients/auth_client.dart";
import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/models/create_business.dart";
import "package:capital_commons/repositories/business_repository.dart";
import "package:cloud_functions/cloud_functions.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "business_signup_cubit.freezed.dart";

class BusinessSignupCubit extends Cubit<BusinessSignupState> {
  BusinessSignupCubit() : super(const BusinessSignupState());

  final _authClient = getIt<AuthClient>();
  final _businessRepository = getIt<BusinessRepository>();
  final _firebaseFunctions = FirebaseFunctions.instance;

  // ===== Update account info =====
  void updateAccountInfo(String email, String password) {
    emit(state.copyWith(email: email, password: password));
  }

  // ===== Update business info =====
  void updateBusinessInfo({
    required String name,
    required String address,
    required String type,
    required String yearFounded,
  }) {
    emit(
      state.copyWith(
        businessName: name,
        businessAddress: address,
        businessType: type,
        yearFounded: yearFounded,
      ),
    );
  }

  // ===== Update financials =====
  void updateFinancials({
    required double revenue,
    required double expenses,
    required double netProfit,
    required String period,
    String? plFilePath,
  }) {
    emit(
      state.copyWith(
        revenue: revenue,
        expenses: expenses,
        netProfit: netProfit,
        financialPeriod: period,
        plFilePath: plFilePath,
      ),
    );

    // Auto-calculate valuation when financials are updated
    calculateValuation(
      revenue: revenue,
      expenses: expenses,
      netProfit: netProfit,
    );
  }

  // ===== Update shares =====
  void updateShares({
    required int totalShares,
    required double pricePerShare,
    required double dividend,
  }) {
    emit(
      state.copyWith(
        totalShares: totalShares,
        pricePerShare: pricePerShare,
        dividendPercentage: dividend,
      ),
    );
  }

  // ===== Accept valuation =====
  void acceptValuation() {
    emit(state.copyWith(valuationAccepted: true));
  }

  // ===== Accept terms =====
  void acceptTerms() {
    emit(state.copyWith(termsAccepted: true));
  }

  // ===== Sign up user with email =====
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
      Log.error("AuthClientException occurred while signing up: $e");
      emit(
        state.copyWith(
          signupStatus: LoadingStatus.failure,
          message: "An error occurred while signing up",
        ),
      );
      emit(state.copyWith(message: null));
    }
  }

  // ===== Fetch revenue & expenses from P&L Cloud Function =====
  Future<Map<String, double>?> getRevenueAndExpensesFromPL(
    String plPath,
  ) async {
    emit(state.copyWith(financialsStatus: LoadingStatus.loading));

    try {
      final res = await _firebaseFunctions
          .httpsCallable("get_revenue_and_expenses_from_pl_statement")
          .call({"pl_statement_path": plPath});

      final data = res.data;
      if (data is! Map<String, dynamic>) throw Exception("Invalid response");

      if (data["error"] != null) throw Exception(data["error"]);

      final revenue = (data["revenue"] as num?)?.toDouble() ?? 0;
      final expenses = (data["expenses"] as num?)?.toDouble() ?? 0;

      emit(state.copyWith(financialsStatus: LoadingStatus.success));
      return {"revenue": revenue, "expenses": expenses};
    } catch (e) {
      Log.error("Error fetching revenue/expenses from PL: $e");
      emit(
        state.copyWith(
          financialsStatus: LoadingStatus.failure,
          message: "Failed to fetch revenue and expenses from P&L",
        ),
      );
      emit(state.copyWith(message: null));
      return null;
    }
  }

  // ===== Calculate Valuation & Funding Cap =====
  void calculateValuation({
    required double revenue,
    required double expenses,
    required double netProfit,
  }) {
    // Valuation formula: 10x net profit
    final valuation = netProfit * 10;
    // Funding cap: 40% of valuation
    final fundingCap = valuation * 0.4;

    emit(state.copyWith(valuation: valuation, fundingCap: fundingCap));
  }

  // ===== Final submission =====
  Future<void> submitBusinessSignup() async {
    emit(state.copyWith(signupStatus: LoadingStatus.loading));

    // Validate all required fields
    if (state.email == null ||
        state.password == null ||
        state.businessName == null ||
        state.businessAddress == null ||
        state.businessType == null ||
        state.yearFounded == null ||
        state.revenue == null ||
        state.expenses == null ||
        state.netProfit == null ||
        state.totalShares == null ||
        state.pricePerShare == null ||
        state.dividendPercentage == null ||
        !state.termsAccepted) {
      emit(
        state.copyWith(
          signupStatus: LoadingStatus.failure,
          message: "Missing required fields",
        ),
      );
      emit(state.copyWith(message: null));
      return;
    }

    try {
      // 1. Sign up user
      await signUpWithEmail(email: state.email!, password: state.password!);

      final user = _authClient.currentUser1;
      if (user == null) {
        emit(
          state.copyWith(
            signupStatus: LoadingStatus.failure,
            message: "User not signed in",
          ),
        );
        emit(state.copyWith(message: null));
        return;
      }

      // 2. Create business in Firestore
      await _businessRepository.createBusiness(
        CreateBusiness(
          uid: user.uid,
          name: state.businessName!,
          description: "",
          industry: state.businessType!,
          logoFilepath: "",
          plDocFilepath: state.plFilePath ?? "",
          projectedRevenue: state.revenue!,
          projectedExpenses: state.expenses!,
          projectedProfit: state.netProfit!,
          valuation: state.valuation ?? 0,
          totalSharesIssued: state.totalShares!,
          sharePrice: state.pricePerShare!,
          dividendPercentage: state.dividendPercentage!,
          isApproved: false,
          address: state.businessAddress!,
          amountRaised: 0,
          numInvestors: 0,
          goal: state.fundingCap ?? 0,
          yearFounded: state.yearFounded!,
        ),
      );

      emit(state.copyWith(signupStatus: LoadingStatus.success));
    } catch (e) {
      Log.error("Error submitting business signup: $e");
      emit(
        state.copyWith(
          signupStatus: LoadingStatus.failure,
          message: "Failed to complete signup",
        ),
      );
      emit(state.copyWith(message: null));
    }
  }
}

@freezed
sealed class BusinessSignupState with _$BusinessSignupState {
  const factory BusinessSignupState({
    @Default(LoadingStatus.initial) LoadingStatus signupStatus,
    @Default(LoadingStatus.initial) LoadingStatus financialsStatus,

    // Stage 1: Account
    String? email,
    String? password,

    // Stage 2: Business Info
    String? businessName,
    String? businessAddress,
    String? businessType,
    String? yearFounded,

    // Stage 3: Financials
    double? revenue,
    double? expenses,
    double? netProfit,
    String? financialPeriod,
    String? plFilePath,

    // Stage 4: Valuation
    double? valuation,
    double? fundingCap,
    @Default(false) bool valuationAccepted,

    // Stage 5: Shares
    int? totalShares,
    double? pricePerShare,
    double? dividendPercentage,

    // Stage 6: Legal
    @Default(false) bool termsAccepted,

    String? message,
  }) = _BusinessSignupState;
}
