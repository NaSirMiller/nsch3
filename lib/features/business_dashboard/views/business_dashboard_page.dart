import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:capital_commons/features/business_dashboard/widgets/dashboard_header.dart";
import "package:capital_commons/features/business_dashboard/widgets/stats_overview.dart";
import "package:capital_commons/features/business_dashboard/widgets/funding_progress.dart";
import "package:capital_commons/features/business_dashboard/widgets/share_price_chart.dart";
import "package:capital_commons/features/business_dashboard/widgets/investor_list.dart";
import "package:capital_commons/features/business_dashboard/widgets/dividend_schedule.dart";
import "package:capital_commons/features/business_dashboard/widgets/quick_actions.dart";

class BusinessDashboardPage extends HookWidget {
  const BusinessDashboardPage({super.key});

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
                title: const Text(
                  "Business Dashboard",
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

                    // Stats Overview
                    const StatsOverview(),
                    const SizedBox(height: 24),

                    // Funding Progress
                    const FundingProgress(),
                    const SizedBox(height: 24),

                    // Two column layout for desktop
                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const SharePriceChart(),
                                const SizedBox(height: 24),
                                const InvestorList(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              children: [
                                const DividendSchedule(),
                                const SizedBox(height: 24),
                                const QuickActions(),
                              ],
                            ),
                          ),
                        ],
                      )
                    else ...[
                      // Stacked layout for mobile/tablet
                      const SharePriceChart(),
                      const SizedBox(height: 24),
                      const DividendSchedule(),
                      const SizedBox(height: 24),
                      const QuickActions(),
                      const SizedBox(height: 24),
                      const InvestorList(),
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
