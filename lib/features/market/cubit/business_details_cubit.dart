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
            message: "Couldn't load stock",
          ),
        );
      }

      emit(
        state.copyWith(
          loadBusinessStatus: LoadingStatus.loading,
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
          message: "Couldn't load stock",
        ),
      );
    }
  }
}

@freezed
sealed class BusinessDetailsState with _$BusinessDetailsState {
  const factory BusinessDetailsState({
    @Default(LoadingStatus.initial) LoadingStatus loadBusinessStatus,
    Business? business,
    String? message,
  }) = _BusinessDetailsState;
}
