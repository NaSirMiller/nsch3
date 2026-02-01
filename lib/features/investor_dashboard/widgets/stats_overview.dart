import "package:flutter/material.dart";
import "package:capital_commons/shared/metric_card.dart";

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Desktop layout: single row
        if (isDesktop) {
          return Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Shares Owned",
                  value: "342",
                  subtitle: "Across all businesses",
                  icon: Icons.pie_chart,
                  color: const Color(0xFF4A90D9),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "Portfolio Value",
                  value: "\$18,240",
                  subtitle: "Current market value",
                  icon: Icons.account_balance_wallet,
                  color: const Color(0xFF2ECC71),
                  trend: "+6.1%",
                  trendPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "Total Invested",
                  value: "\$15,900",
                  subtitle: "Lifetime investments",
                  icon: Icons.trending_up,
                  color: const Color(0xFFE67E22),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "ROI",
                  value: "+14.7%",
                  subtitle: "Overall return",
                  icon: Icons.show_chart,
                  color: const Color(0xFF9B59B6),
                  trend: "+1.2%",
                  trendPositive: true,
                ),
              ),
            ],
          );
        } 
        // Tablet layout: two rows
        else if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: MetricCard(
                      title: "Shares Owned",
                      value: "342",
                      subtitle: "Across all businesses",
                      icon: Icons.pie_chart,
                      color: const Color(0xFF4A90D9),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: "Portfolio Value",
                      value: "\$18,240",
                      subtitle: "Current market value",
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFF2ECC71),
                      trend: "+6.1%",
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
                      title: "Total Invested",
                      value: "\$15,900",
                      subtitle: "Lifetime investments",
                      icon: Icons.trending_up,
                      color: const Color(0xFFE67E22),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: "ROI",
                      value: "+14.7%",
                      subtitle: "Overall return",
                      icon: Icons.show_chart,
                      color: const Color(0xFF9B59B6),
                      trend: "+1.2%",
                      trendPositive: true,
                    ),
                  ),
                ],
              ),
            ],
          );
        } 
        // Mobile layout: stacked
        else {
          return Column(
            children: const [
              MetricCard(
                title: "Shares Owned",
                value: "342",
                subtitle: "Across all businesses",
                icon: Icons.pie_chart,
                color: Color(0xFF4A90D9),
              ),
              SizedBox(height: 12),
              MetricCard(
                title: "Portfolio Value",
                value: "\$18,240",
                subtitle: "Current market value",
                icon: Icons.account_balance_wallet,
                color: Color(0xFF2ECC71),
                trend: "+6.1%",
                trendPositive: true,
              ),
              SizedBox(height: 12),
              MetricCard(
                title: "Total Invested",
                value: "\$15,900",
                subtitle: "Lifetime investments",
                icon: Icons.trending_up,
                color: Color(0xFFE67E22),
              ),
              SizedBox(height: 12),
              MetricCard(
                title: "ROI",
                value: "+14.7%",
                subtitle: "Overall return",
                icon: Icons.show_chart,
                color: Color(0xFF9B59B6),
                trend: "+1.2%",
                trendPositive: true,
              ),
            ],
          );
        }
      },
    );
  }
}
