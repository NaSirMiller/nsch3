import "package:flutter/material.dart";
import "package:capital_commons/shared/dashboard_section.dart";
import "package:capital_commons/shared/investor_row.dart";

class HoldingsList extends StatelessWidget {
  const HoldingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: "My Holdings",
      child: Column(
        children: const [
          SizedBox(height: 12),
          InvestorRow(
            name: "Acme Corp",
            shares: 120,
            date: "Avg \$24.10",
            amount: "\$2,892",
          ),
          SizedBox(height: 8),
          InvestorRow(
            name: "Green Energy LLC",
            shares: 80,
            date: "Avg \$19.50",
            amount: "\$1,560",
          ),
        ],
      ),
    );
  }
}
