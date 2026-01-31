import "package:flutter/material.dart";
import "shared/metric_card.dart";

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop) {
          return Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Total Raised",
                  value: "\$87,500",
                  subtitle: "87.5% of goal",
                  icon: Icons.account_balance_wallet_outlined,
                  color: const Color(0xFF2ECC71),
                  trend: "+\$12,500",
                  trendPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "Investors",
                  value: "24",
                  subtitle: "Active shareholders",
                  icon: Icons.people_outline,
                  color: const Color(0xFF4A90D9),
                  trend: "+3 this week",
                  trendPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "Share Price",
                  value: "\$125.00",
                  subtitle: "Current market value",
                  icon: Icons.show_chart,
                  color: const Color(0xFFE74C3C),
                  trend: "+\$25.00 (25%)",
                  trendPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "Market Cap",
                  value: "\$125K",
                  subtitle: "1,000 total shares",
                  icon: Icons.pie_chart_outline,
                  color: const Color(0xFF9B59B6),
                  trend: "Fully diluted",
                  trendPositive: null,
                ),
              ),
            ],
          );
        } else if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: "Total Raised",
                      value: "\$87,500",
                      subtitle: "87.5% of goal",
                      icon: Icons.account_balance_wallet_outlined,
                      color: const Color(0xFF2ECC71),
                      trend: "+\$12,500",
                      trendPositive: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: "Investors",
                      value: "24",
                      subtitle: "Active shareholders",
                      icon: Icons.people_outline,
                      color: const Color(0xFF4A90D9),
                      trend: "+3 this week",
                      trendPositive: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: "Share Price",
                      value: "\$125.00",
                      subtitle: "Current market value",
                      icon: Icons.show_chart,
                      color: const Color(0xFFE74C3C),
                      trend: "+\$25.00 (25%)",
                      trendPositive: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: "Market Cap",
                      value: "\$125K",
                      subtitle: "1,000 total shares",
                      icon: Icons.pie_chart_outline,
                      color: const Color(0xFF9B59B6),
                      trend: "Fully diluted",
                      trendPositive: null,
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: [
              MetricCard(
                title: "Total Raised",
                value: "\$87,500",
                subtitle: "87.5% of goal",
                icon: Icons.account_balance_wallet_outlined,
                color: const Color(0xFF2ECC71),
                trend: "+\$12,500",
                trendPositive: true,
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: "Investors",
                value: "24",
                subtitle: "Active shareholders",
                icon: Icons.people_outline,
                color: const Color(0xFF4A90D9),
                trend: "+3 this week",
                trendPositive: true,
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: "Share Price",
                value: "\$125.00",
                subtitle: "Current market value",
                icon: Icons.show_chart,
                color: const Color(0xFFE74C3C),
                trend: "+\$25.00 (25%)",
                trendPositive: true,
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: "Market Cap",
                value: "\$125K",
                subtitle: "1,000 total shares",
                icon: Icons.pie_chart_outline,
                color: const Color(0xFF9B59B6),
                trend: "Fully diluted",
                trendPositive: null,
              ),
            ],
          );
        }
      },
    );
  }
}
