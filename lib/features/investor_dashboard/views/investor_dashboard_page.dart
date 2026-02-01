import "package:capital_commons/features/investor_dashboard/cubit/investor_dashboard_cubit.dart";
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
import "package:capital_commons/models/business.dart";

// Temporary mock businesses
final mockBusinesses = [
  {
    "uid": "biz_001",
    "name": "Green Valley Farms",
    "description": "Organic produce and local goods",
    "industry": "Agriculture",
    "logoFilepath": "", // Changed from null to empty string
    "plDocFilepath": "", // Changed from null to empty string
    "projectedRevenue": 450000.0,
    "projectedExpenses": 280000.0,
    "projectedProfit": 170000.0,
    "valuation": 1200000.0,
    "totalSharesIssued": 100000,
    "sharePrice": 12.0,
    "dividendPercentage": 5.0,
    "isApproved": true,
    "address": "123 Farm Lane, Albany, NY",
    "goal": 250000.0,
    "numInvestors": 48,
    "amountRaised": 185000.0, // Added .0 to ensure it's a double
    "yearFounded": "2018",
  },
  {
    "uid": "biz_002",
    "name": "Hudson Tech Co",
    "description": "IoT solutions for smart buildings",
    "industry": "Technology",
    "logoFilepath": "logos/hudson.png",
    "plDocFilepath": "docs/hudson_pl.pdf",
    "projectedRevenue": 950000.0,
    "projectedExpenses": 640000.0,
    "projectedProfit": 310000.0,
    "valuation": 2400000.0,
    "totalSharesIssued": 200000,
    "sharePrice": 15.0,
    "dividendPercentage": 3.5,
    "isApproved": false,
    "address": "77 River St, Troy, NY",
    "goal": 500000.0,
    "numInvestors": 102,
    "amountRaised": 320000.0, // Added .0 to ensure it's a double
    "yearFounded": "2021",
  },
];

final List<Business> businesses = mockBusinesses
    .map((e) => Business.fromJson(e as Map<String, dynamic>))
    .toList();

class InvestorDashboardPage extends HookWidget {
  const InvestorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return BlocProvider(
      create: (_) => InvestorDashboardCubit()..loadHoldings(),
      child: BlocBuilder<InvestorDashboardCubit, InvestorDashboardState>(
        builder: (context, state) {
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

                      /// Inside SliverAppBar actions:
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.white70,
                        ),
                        IconButton(
                          onPressed: () {
                            // Navigate to the Settings page
                            context.go('/settings');
                          },
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

                          const StatsOverview(),
                          const SizedBox(height: 24),

                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      const HoldingsList(),
                                      const SizedBox(height: 24),
                                      AvailableBusinessesList(
                                        businesses: businesses,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                const Expanded(
                                  child: Column(
                                    children: [
                                      TransactionsList(),
                                      SizedBox(height: 24),
                                      QuickActions(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            const HoldingsList(),
                            const SizedBox(height: 24),
                            AvailableBusinessesList(businesses: businesses),
                            const SizedBox(height: 24),
                            const TransactionsList(),
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
