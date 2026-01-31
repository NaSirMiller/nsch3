import "package:flutter/material.dart";
import "shared/dashboard_section.dart";

class DividendSchedule extends StatelessWidget {
  const DividendSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: "Next Dividend",
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Next payment card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF4A90D9).withOpacity(0.2),
                  const Color(0xFF4A90D9).withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4A90D9).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: const Color(0xFF4A90D9),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "March 31, 2025",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "\$4,375",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4A90D9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total Payout (5% of \$87,500)",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Details
          _DetailRow(label: "Payment Frequency", value: "Quarterly"),
          const SizedBox(height: 8),
          _DetailRow(label: "Per Share Dividend", value: "\$5.00"),
          const SizedBox(height: 8),
          _DetailRow(label: "Shareholders", value: "24 investors"),

          const SizedBox(height: 16),

          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF2ECC71).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: const Color(0xFF2ECC71),
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  "On Track • Profits reported",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2ECC71),
                    fontWeight: FontWeight.w600,
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
