import "package:flutter/material.dart";

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Row(
        children: [
          // Business logo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4A90D9).withOpacity(0.4),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.business,
              color: Color(0xFF4A90D9),
              size: 32,
            ),
          ),

          const SizedBox(width: 20),

          // Business info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Capital Coffee Co.",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF2ECC71).withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            color: const Color(0xFF2ECC71),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Verified",
                            style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFF2ECC71),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Troy, NY • Coffee Shop",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90D9).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Active Listing",
                        style: TextStyle(
                          fontSize: 11,
                          color: const Color(0xFF4A90D9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Listed Since",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Jan 15, 2025",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
