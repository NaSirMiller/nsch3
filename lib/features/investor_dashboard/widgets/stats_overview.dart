import "package:flutter/material.dart";
import "package:capital_commons/shared/metric_card.dart";

class StatsOverview extends StatelessWidget {
  final int totalShares;
  final double portfolioValue;
  final bool isLoading;

  const StatsOverview({
    super.key,
    required this.totalShares,
    required this.portfolioValue,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768;

    // Calculate derived stats
    final totalInvested = portfolioValue;
    final roi = totalInvested > 0
        ? ((portfolioValue - totalInvested) / totalInvested * 100)
        : 15.0; // Placeholder 15% when no data

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop) {
          return Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: "Shares Owned",
                  value: isLoading ? "..." : totalShares.toString(),
                  subtitle: "Across all businesses",
                  icon: Icons.pie_chart,
                  color: const Color(0xFF4A90D9),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "Portfolio Value",
                  value: isLoading
                      ? "..."
                      : portfolioValue > 0
                      ? "\$${portfolioValue.toStringAsFixed(2)}"
                      : "\$0.00",
                  subtitle: "Current market value",
                  icon: Icons.account_balance_wallet,
                  color: const Color(0xFF2ECC71),
                  trend: portfolioValue > 0 ? "+6.1%" : null,
                  trendPositive: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "Total Invested",
                  value: isLoading
                      ? "..."
                      : totalInvested > 0
                      ? "\$${totalInvested.toStringAsFixed(2)}"
                      : "\$0.00",
                  subtitle: "Lifetime investments",
                  icon: Icons.trending_up,
                  color: const Color(0xFFE67E22),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MetricCard(
                  title: "ROI",
                  value: isLoading ? "..." : "${roi.toStringAsFixed(1)}%",
                  subtitle: portfolioValue > 0
                      ? "Overall return"
                      : "Placeholder",
                  icon: Icons.show_chart,
                  color: const Color(0xFF9B59B6),
                  trend: portfolioValue > 0 ? "+1.2%" : null,
                  trendPositive: roi > 0,
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
                      title: "Shares Owned",
                      value: isLoading ? "..." : totalShares.toString(),
                      subtitle: "Across all businesses",
                      icon: Icons.pie_chart,
                      color: const Color(0xFF4A90D9),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: "Portfolio Value",
                      value: isLoading
                          ? "..."
                          : portfolioValue > 0
                          ? "\$${portfolioValue.toStringAsFixed(2)}"
                          : "\$0.00",
                      subtitle: "Current market value",
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFF2ECC71),
                      trend: portfolioValue > 0 ? "+6.1%" : null,
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
                      value: isLoading
                          ? "..."
                          : totalInvested > 0
                          ? "\$${totalInvested.toStringAsFixed(2)}"
                          : "\$0.00",
                      subtitle: "Lifetime investments",
                      icon: Icons.trending_up,
                      color: const Color(0xFFE67E22),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MetricCard(
                      title: "ROI",
                      value: isLoading ? "..." : "${roi.toStringAsFixed(1)}%",
                      subtitle: portfolioValue > 0
                          ? "Overall return"
                          : "Placeholder",
                      icon: Icons.show_chart,
                      color: const Color(0xFF9B59B6),
                      trend: portfolioValue > 0 ? "+1.2%" : null,
                      trendPositive: roi > 0,
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
                title: "Shares Owned",
                value: isLoading ? "..." : totalShares.toString(),
                subtitle: "Across all businesses",
                icon: Icons.pie_chart,
                color: const Color(0xFF4A90D9),
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: "Portfolio Value",
                value: isLoading
                    ? "..."
                    : portfolioValue > 0
                    ? "\$${portfolioValue.toStringAsFixed(2)}"
                    : "\$0.00",
                subtitle: "Current market value",
                icon: Icons.account_balance_wallet,
                color: const Color(0xFF2ECC71),
                trend: portfolioValue > 0 ? "+6.1%" : null,
                trendPositive: true,
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: "Total Invested",
                value: isLoading
                    ? "..."
                    : totalInvested > 0
                    ? "\$${totalInvested.toStringAsFixed(2)}"
                    : "\$0.00",
                subtitle: "Lifetime investments",
                icon: Icons.trending_up,
                color: const Color(0xFFE67E22),
              ),
              const SizedBox(height: 12),
              MetricCard(
                title: "ROI",
                value: isLoading ? "..." : "${roi.toStringAsFixed(1)}%",
                subtitle: portfolioValue > 0 ? "Overall return" : "Placeholder",
                icon: Icons.show_chart,
                color: const Color(0xFF9B59B6),
                trend: portfolioValue > 0 ? "+1.2%" : null,
                trendPositive: roi > 0,
              ),
            ],
          );
        }
      },
    );
  }
}
