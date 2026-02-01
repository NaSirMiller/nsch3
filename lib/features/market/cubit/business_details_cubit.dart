import "package:capital_commons/clients/exchange_client.dart";
import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/models/business.dart";
import "package:capital_commons/repositories/business_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "business_details_cubit.freezed.dart";

class BusinessDetailsCubit extends Cubit<BusinessDetailsState> {
  BusinessDetailsCubit() : super(const BusinessDetailsState());

  final _businessRepository = getIt<BusinessRepository>();
  final _exchangeClient = getIt<ExchangeClient>();

  Future<void> loadBusiness(String businessId) async {
    emit(
      state.copyWith(loadBusinessStatus: LoadingStatus.loading, business: null),
    );
    try {
      final business = await _businessRepository.getBusinessById(businessId);
      if (business == null) {
        emit(
          state.copyWith(
            loadBusinessStatus: LoadingStatus.failure,
            message: "Couldn't load business",
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          loadBusinessStatus: LoadingStatus.success,
          business: business,
        ),
      );
    } on BusinessRepositoryException catch (e) {
      Log.error(
        "BusinessRepositoryException occurred while loading business: $e",
      );
      emit(
        state.copyWith(
          loadBusinessStatus: LoadingStatus.failure,
          message: "Couldn't load business",
        ),
      );
    }
  }

  /// Purchase shares from business
  Future<void> purchaseShares({
    required String investorId,
    required int numShares,
  }) async {
    if (state.business == null) {
      emit(
        state.copyWith(
          purchaseStatus: LoadingStatus.failure,
          message: "Business not loaded",
        ),
      );
      emit(state.copyWith(message: null));
      return;
    }

    emit(state.copyWith(purchaseStatus: LoadingStatus.loading));

    try {
      await _exchangeClient.exchangeBusinessToInvestor(
        businessId: state.business!.uid,
        investorId: investorId,
        numShares: numShares,
      );

      emit(
        state.copyWith(
          purchaseStatus: LoadingStatus.success,
          message: "Successfully purchased $numShares shares!",
        ),
      );
      emit(state.copyWith(message: null));

      // Reload business to get updated data
      await loadBusiness(state.business!.uid);
    } on ExchangeClientException catch (e) {
      Log.error("ExchangeClientException during purchase: $e");
      emit(
        state.copyWith(
          purchaseStatus: LoadingStatus.failure,
          message: e.message,
        ),
      );
      emit(state.copyWith(message: null));
    } catch (e) {
      Log.error("Unexpected error during purchase: $e");
      emit(
        state.copyWith(
          purchaseStatus: LoadingStatus.failure,
          message: "Failed to purchase shares",
        ),
      );
      emit(state.copyWith(message: null));
    }
  }

  /// Reset purchase status
  void resetPurchaseStatus() {
    emit(state.copyWith(purchaseStatus: LoadingStatus.initial, message: null));
  }
}

@freezed
sealed class BusinessDetailsState with _$BusinessDetailsState {
  const factory BusinessDetailsState({
    @Default(LoadingStatus.initial) LoadingStatus loadBusinessStatus,
    @Default(LoadingStatus.initial) LoadingStatus purchaseStatus,
    Business? business,
    String? message,
  }) = _BusinessDetailsState;
}
