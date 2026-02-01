import "package:flutter/material.dart";
import "package:capital_commons/shared/dashboard_section.dart";
import "package:capital_commons/shared/investor_row.dart";
import "package:capital_commons/models/holding.dart";

class HoldingsList extends StatelessWidget {
  final List<Holding> holdings;
  final bool isLoading;

  const HoldingsList({
    super.key,
    required this.holdings,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DashboardSection(
        title: "My Holdings",
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: Color(0xFF4A90D9)),
        ),
      );
    }

    if (holdings.isEmpty) {
      return DashboardSection(
        title: "My Holdings",
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: Text(
            "No holdings yet. Start investing!",
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ),
      );
    }

    return DashboardSection(
      title: "My Holdings",
      child: Column(
        children: [
          const SizedBox(height: 12),
          ...holdings.map((holding) {
            final avgPrice = holding.sharePrice;

            final currentValue = holding.numShares * holding.sharePrice;
            final displayName =
                holding.businessName ?? holding.ticker ?? "Unknown Business";

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InvestorRow(
                name: displayName,
                shares: holding.numShares,
                date: "Avg \$${avgPrice.toStringAsFixed(2)}",
                amount: "\$${currentValue.toStringAsFixed(2)}",
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
