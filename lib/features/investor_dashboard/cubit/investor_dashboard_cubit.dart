import "package:capital_commons/clients/auth_client.dart";
import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/models/holding.dart";
import "package:capital_commons/repositories/holdings_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "investor_dashboard_cubit.freezed.dart";

class InvestorDashboardCubit extends Cubit<InvestorDashboardState> {
  InvestorDashboardCubit({HoldingsRepository? holdingsRepository})
    : _holdingsRepository = holdingsRepository ?? HoldingsRepository(),
      super(const InvestorDashboardState());

  final _authClient = getIt<AuthClient>();
  final HoldingsRepository _holdingsRepository;

  /// Load holdings for the current investor
  Future<void> loadHoldings() async {
    emit(state.copyWith(loadHoldings: LoadingStatus.loading));

    try {
      // Get current user ID from auth client
      final user = _authClient.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // Fetch holdings
      final holdings = await _holdingsRepository.getHoldingsByInvestorId(
        user.uid,
      );

      // Update state
      emit(
        state.copyWith(holdings: holdings, loadHoldings: LoadingStatus.success),
      );
    } catch (e, st) {
      Log.error("Failed to load holdings", error: e, stackTrace: st);
      emit(
        state.copyWith(
          loadHoldings: LoadingStatus.failure,
          message: "Couldn't load holdings",
        ),
      );
      emit(state.copyWith(message: null));
    }
  }
}

@freezed
sealed class InvestorDashboardState with _$InvestorDashboardState {
  const factory InvestorDashboardState({
    @Default(LoadingStatus.initial) LoadingStatus loadHoldings,
    @Default([]) List<Holding> holdings,
    String? message,
  }) = _InvestorDashboardState;
}
