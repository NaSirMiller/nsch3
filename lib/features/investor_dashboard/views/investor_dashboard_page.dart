import "package:capital_commons/features/investor_dashboard/cubit/investor_dashboard_cubit.dart";
import "package:capital_commons/core/loading_status.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "package:capital_commons/features/investor_dashboard/widgets/dashboard_header.dart";
import "package:capital_commons/features/investor_dashboard/widgets/stats_overview.dart";
import "package:capital_commons/features/investor_dashboard/widgets/holdings_list.dart";
import "package:capital_commons/features/investor_dashboard/widgets/transactions_list.dart";
import "package:capital_commons/features/investor_dashboard/widgets/available_businesses_list.dart";
import "package:capital_commons/features/investor_dashboard/widgets/quick_actions.dart";

class InvestorDashboardPage extends HookWidget {
  const InvestorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return BlocProvider(
      create: (_) => InvestorDashboardCubit()..loadDashboardData(),
      child: BlocBuilder<InvestorDashboardCubit, InvestorDashboardState>(
        builder: (context, state) {
          final isLoading =
              state.loadHoldingsStatus.isLoading ||
              state.loadTransactionsStatus.isLoading;

          return Scaffold(
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A1628),
                    Color(0xFF1A2E4A),
                    Color(0xFF0D3B66),
                  ],
                ),
              ),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    /// App bar
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: Colors.white),
                      title: const Text(
                        "Investor Dashboard",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.white70,
                        ),
                        IconButton(
                          onPressed: () => context.go('/settings'),
                          icon: const Icon(Icons.settings_outlined),
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    /// Content
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
                        vertical: 24,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const DashboardHeader(),
                          const SizedBox(height: 24),

                          // Stats Overview with real data
                          StatsOverview(
                            totalShares: state.totalSharesOwned,
                            portfolioValue: state.totalPortfolioValue,
                            isLoading: isLoading,
                          ),
                          const SizedBox(height: 24),

                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      HoldingsList(
                                        holdings: state.holdings,
                                        isLoading:
                                            state.loadHoldingsStatus.isLoading,
                                      ),
                                      const SizedBox(height: 24),
                                      const AvailableBusinessesList(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    children: [
                                      TransactionsList(
                                        transactions: state.recentTransactions,
                                        isLoading: state
                                            .loadTransactionsStatus
                                            .isLoading,
                                      ),
                                      const SizedBox(height: 24),
                                      const QuickActions(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            HoldingsList(
                              holdings: state.holdings,
                              isLoading: state.loadHoldingsStatus.isLoading,
                            ),
                            const SizedBox(height: 24),
                            const AvailableBusinessesList(),
                            const SizedBox(height: 24),
                            TransactionsList(
                              transactions: state.recentTransactions,
                              isLoading: state.loadTransactionsStatus.isLoading,
                            ),
                            const SizedBox(height: 24),
                            const QuickActions(),
                          ],

                          const SizedBox(height: 40),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
