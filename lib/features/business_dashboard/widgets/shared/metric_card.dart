import "package:flutter/material.dart";

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.trend,
    this.trendPositive,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? trend;
  final bool? trendPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              if (trend != null && trendPositive != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: trendPositive!
                        ? const Color(0xFF2ECC71).withOpacity(0.15)
                        : const Color(0xFFE74C3C).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendPositive!
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 12,
                        color: trendPositive!
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFFE74C3C),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: trendPositive!
                              ? const Color(0xFF2ECC71)
                              : const Color(0xFFE74C3C),
                        ),
                      ),
                    ],
                  ),
                )
              else if (trend != null)
                Text(
                  trend!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
