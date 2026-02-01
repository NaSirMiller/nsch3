import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "package:capital_commons/features/investor_dashboard/widgets/dashboard_header.dart";
import "package:capital_commons/features/investor_dashboard/widgets/stats_overview.dart";
import "package:capital_commons/features/investor_dashboard/widgets/holdings_list.dart";
import "package:capital_commons/features/investor_dashboard/widgets/transactions_list.dart";
import "package:capital_commons/features/investor_dashboard/widgets/available_businesses_list.dart";
import "package:capital_commons/features/investor_dashboard/widgets/quick_actions.dart"; // Added import
import "package:capital_commons/models/business.dart";

// Temporary mock businesses
final mockBusinesses = [
  Business(
    uid: "b1",
    name: "Acme Corp",
    description: "Tech startup",
    industry: "Tech",
    logoFilepath: null,
    plDocFilepath: null,
    projectedRevenue: 500000,
    projectedExpenses: 200000,
    projectedProfit: 300000,
    valuation: 2000000,
    totalSharesIssued: 1000,
    sharePrice: 25.0,
    dividendPercentage: 2.0,
    isApproved: true,
  ),
  Business(
    uid: "b2",
    name: "Green Energy LLC",
    description: "Renewable energy",
    industry: "Energy",
    logoFilepath: null,
    plDocFilepath: null,
    projectedRevenue: 750000,
    projectedExpenses: 300000,
    projectedProfit: 450000,
    valuation: 3500000,
    totalSharesIssued: 2000,
    sharePrice: 30.0,
    dividendPercentage: 1.5,
    isApproved: true,
  ),
  Business(
    uid: "b3",
    name: "Blue Ocean Foods",
    description: "Sustainable seafood company",
    industry: "Food & Beverage",
    logoFilepath: null,
    plDocFilepath: null,
    projectedRevenue: 600000,
    projectedExpenses: 250000,
    projectedProfit: 350000,
    valuation: 2500000,
    totalSharesIssued: 1500,
    sharePrice: 20.0,
    dividendPercentage: 1.8,
    isApproved: true,
  ),
];

class InvestorDashboardPage extends HookWidget {
  const InvestorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A1628), Color(0xFF1A2E4A), Color(0xFF0D3B66)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App bar
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
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              // Content
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
                  vertical: 24,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Header
                    const DashboardHeader(),
                    const SizedBox(height: 24),

                    // Portfolio metrics
                    const StatsOverview(),
                    const SizedBox(height: 24),

                    // Desktop layout
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                // My Holdings first
                                const HoldingsList(),
                                const SizedBox(height: 24),

                                // Available businesses
                                AvailableBusinessesList(
                                  businesses: mockBusinesses,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              children: [
                                // Transactions
                                const TransactionsList(),
                                const SizedBox(height: 24),

                                // Quick Actions added back
                                const QuickActions(),
                              ],
                            ),
                          ),
                        ],
                      )
                    else ...[
                      // Mobile / tablet stacked layout
                      const HoldingsList(),
                      const SizedBox(height: 24),
                      AvailableBusinessesList(businesses: mockBusinesses),
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
  }
}
