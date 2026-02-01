import "package:flutter/material.dart";
import "package:capital_commons/shared/dashboard_section.dart";
import "package:capital_commons/shared/investor_row.dart";

class TransactionsList extends StatelessWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: "Recent Transactions",
      child: Column(
        children: const [
          SizedBox(height: 12),
          InvestorRow(
            name: "Acme Corp",
            shares: 20,
            date: "Jan 24, 2026",
            amount: "-\$482",
          ),
          SizedBox(height: 8),
          InvestorRow(
            name: "Dividend Payout",
            shares: 0,
            date: "Jan 10, 2026",
            amount: "+\$120",
          ),
        ],
      ),
    );
  }
}
