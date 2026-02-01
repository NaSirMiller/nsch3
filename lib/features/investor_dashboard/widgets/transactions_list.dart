import "package:flutter/material.dart";
import "package:capital_commons/shared/dashboard_section.dart";
import "package:capital_commons/shared/investor_row.dart";
import "package:capital_commons/models/transaction.dart";
import "package:intl/intl.dart";

class TransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final bool isLoading;

  const TransactionsList({
    super.key,
    required this.transactions,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DashboardSection(
        title: "Recent Transactions",
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: Color(0xFF4A90D9)),
        ),
      );
    }

    if (transactions.isEmpty) {
      return DashboardSection(
        title: "Recent Transactions",
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: Text(
            "No transactions yet",
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ),
      );
    }

    return DashboardSection(
      title: "Recent Transactions",
      child: Column(
        children: [
          const SizedBox(height: 12),
          ...transactions.take(5).map((transaction) {
            final dateFormat = DateFormat('MMM dd, yyyy');
            final totalAmount =
                transaction.numShares * transaction.pricePerShare;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InvestorRow(
                name: "Transaction", // You might want to fetch business name
                shares: transaction.numShares,
                date: dateFormat.format(transaction.timestamp),
                amount: "-\$${totalAmount.toStringAsFixed(0)}",
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
