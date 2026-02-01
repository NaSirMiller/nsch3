import "package:flutter/material.dart";
import "package:capital_commons/shared/dashboard_section.dart";
import "package:capital_commons/shared/investor_row.dart";
class InvestorList extends StatelessWidget {
  const InvestorList({super.key});

  @override
  Widget build(BuildContext context) {
    final investors = [
      {
        "name": "Alice Johnson",
        "shares": 50,
        "date": "2 hours ago",
        "amount": "\$6,250",
      },
      {
        "name": "Bob Smith",
        "shares": 25,
        "date": "5 hours ago",
        "amount": "\$3,125",
      },
      {
        "name": "Carol White",
        "shares": 100,
        "date": "1 day ago",
        "amount": "\$12,500",
      },
      {
        "name": "David Lee",
        "shares": 15,
        "date": "2 days ago",
        "amount": "\$1,875",
      },
      {
        "name": "Emma Davis",
        "shares": 75,
        "date": "3 days ago",
        "amount": "\$9,375",
      },
    ];

    return DashboardSection(
      title: "Recent Investors",
      action: TextButton(
        onPressed: () {},
        child: const Text(
          "View All",
          style: TextStyle(color: Color(0xFF4A90D9), fontSize: 13),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          ...investors.map(
            (investor) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InvestorRow(
                name: investor["name"] as String,
                shares: investor["shares"] as int,
                date: investor["date"] as String,
                amount: investor["amount"] as String,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
