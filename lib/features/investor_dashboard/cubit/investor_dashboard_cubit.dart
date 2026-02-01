import "package:capital_commons/clients/auth_client.dart";
import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/models/holding.dart";
import "package:capital_commons/models/transaction.dart";
import "package:capital_commons/repositories/holdings_repository.dart";
import "package:capital_commons/repositories/transaction_repository.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "investor_dashboard_cubit.freezed.dart";

class InvestorDashboardCubit extends Cubit<InvestorDashboardState> {
  InvestorDashboardCubit({
    HoldingsRepository? holdingsRepository,
    TransactionRepository? transactionRepository,
  }) : _holdingsRepository = holdingsRepository ?? getIt<HoldingsRepository>(),
       _transactionRepository =
           transactionRepository ?? getIt<TransactionRepository>(),
       super(const InvestorDashboardState());

  final _authClient = getIt<AuthClient>();
  final HoldingsRepository _holdingsRepository;
  final TransactionRepository _transactionRepository;

  /// Load all dashboard data
  Future<void> loadDashboardData() async {
    await Future.wait([loadHoldings(), loadRecentTransactions()]);
  }

  /// Load holdings for the current investor
  Future<void> loadHoldings() async {
    emit(state.copyWith(loadHoldingsStatus: LoadingStatus.loading));

    try {
      final user = _authClient.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final holdings = await _holdingsRepository.getHoldingsByInvestorId(
        user.uid,
      );

      // Calculate portfolio stats
      double totalValue = 0;
      int totalShares = 0;

      for (final holding in holdings) {
        // Total portfolio value = number of shares * current share price
        totalValue += holding.numShares * holding.sharePrice;
        totalShares += holding.numShares;
      }

      emit(
        state.copyWith(
          holdings: holdings,
          loadHoldingsStatus: LoadingStatus.success,
          totalPortfolioValue: totalValue,
          totalSharesOwned: totalShares,
        ),
      );
    } catch (e, st) {
      Log.error("Failed to load holdings", error: e, stackTrace: st);
      emit(
        state.copyWith(
          loadHoldingsStatus: LoadingStatus.failure,
          message: "Couldn't load holdings",
        ),
      );
      emit(state.copyWith(message: null));
    }
  }

  /// Load recent transactions for the current investor
  Future<void> loadRecentTransactions() async {
    emit(state.copyWith(loadTransactionsStatus: LoadingStatus.loading));

    try {
      final user = _authClient.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final transactions = await _transactionRepository
          .getRecentTransactionsByUserId(user.uid, limit: 10);

      emit(
        state.copyWith(
          recentTransactions: transactions,
          loadTransactionsStatus: LoadingStatus.success,
        ),
      );
    } catch (e, st) {
      Log.error("Failed to load transactions", error: e, stackTrace: st);
      emit(
        state.copyWith(
          loadTransactionsStatus: LoadingStatus.failure,
          message: "Couldn't load transactions",
        ),
      );
      emit(state.copyWith(message: null));
    }
  }
}

@freezed
sealed class InvestorDashboardState with _$InvestorDashboardState {
  const factory InvestorDashboardState({
    @Default(LoadingStatus.initial) LoadingStatus loadHoldingsStatus,
    @Default(LoadingStatus.initial) LoadingStatus loadTransactionsStatus,
    @Default([]) List<Holding> holdings,
    @Default([]) List<TransactionModel> recentTransactions,
    @Default(0.0) double totalPortfolioValue,
    @Default(0) int totalSharesOwned,
    String? message,
  }) = _InvestorDashboardState;
}
