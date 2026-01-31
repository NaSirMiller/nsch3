import "package:flutter/material.dart";

class InvestorRow extends StatelessWidget {
  const InvestorRow({
    super.key,
    required this.name,
    required this.shares,
    required this.date,
    required this.amount,
  });

  final String name;
  final int shares;
  final String date;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name[0],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4A90D9),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Name and shares
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "$shares shares • $date",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2ECC71),
            ),
          ),
        ],
      ),
    );
  }
}
