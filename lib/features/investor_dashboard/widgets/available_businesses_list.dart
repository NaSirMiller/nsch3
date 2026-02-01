import "package:flutter/material.dart";
import "package:capital_commons/shared/dashboard_section.dart";
import "package:capital_commons/shared/investor_row.dart";
import "package:capital_commons/models/business.dart"; // Your Business model

class AvailableBusinessesList extends StatelessWidget {
  final List<Business> businesses;

  const AvailableBusinessesList({super.key, required this.businesses});

  @override
  Widget build(BuildContext context) {
    if (businesses.isEmpty) {
      return DashboardSection(
        title: "Available Businesses",
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: Text(
            "No businesses available for investment",
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ),
      );
    }

    return DashboardSection(
      title: "Available Businesses",
      child: Column(
        children: businesses.map((b) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InvestorRow(
              name: b.name,
              shares: b.totalSharesIssued, // or calculate available shares
              date: "N/A",
              amount: "\$${b.sharePrice.toStringAsFixed(2)}",
            ),
          );
        }).toList(),
      ),
    );
  }
}
