import "package:flutter/material.dart";

class FinancialsSection extends StatelessWidget {
  const FinancialsSection({
    super.key,
    required this.revenue,
    required this.expenses,
    required this.netProfit,
  });

  final double revenue;
  final double expenses;
  final double netProfit;

  @override
  Widget build(BuildContext context) {
    final profitMargin = (netProfit / revenue) * 100;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC71).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.assessment_outlined,
                  color: Color(0xFF2ECC71),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Financial Overview",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Last 12 months",
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),

          // Revenue
          _FinancialItem(
            label: "Total Revenue",
            value: "\$${revenue.toStringAsFixed(0)}",
            icon: Icons.trending_up,
            color: const Color(0xFF4A90D9),
          ),

          const SizedBox(height: 16),

          // Expenses
          _FinancialItem(
            label: "Total Expenses",
            value: "\$${expenses.toStringAsFixed(0)}",
            icon: Icons.money_off_outlined,
            color: const Color(0xFFE74C3C),
          ),

          const SizedBox(height: 16),

          Divider(color: Colors.white.withOpacity(0.1)),

          const SizedBox(height: 16),

          // Net Profit
          _FinancialItem(
            label: "Net Profit",
            value: "\$${netProfit.toStringAsFixed(0)}",
            icon: Icons.attach_money,
            color: const Color(0xFF2ECC71),
            isHighlighted: true,
          ),

          const SizedBox(height: 20),

          // Profit margin badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2ECC71).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.pie_chart_outline,
                  color: const Color(0xFF2ECC71),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  "Profit Margin: ${profitMargin.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2ECC71),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialItem extends StatelessWidget {
  const _FinancialItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isHighlighted = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isHighlighted ? 24 : 20,
                  fontWeight: FontWeight.w700,
                  color: isHighlighted ? color : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
