import "package:flutter/material.dart";
import "shared/dashboard_section.dart";

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardSection(
      title: "Quick Actions",
      child: Column(
        children: [
          const SizedBox(height: 16),

          _ActionButton(
            icon: Icons.assessment_outlined,
            label: "Report Profits",
            subtitle: "Q1 2025 reporting due",
            color: const Color(0xFF4A90D9),
            onTap: () {},
          ),

          const SizedBox(height: 12),

          _ActionButton(
            icon: Icons.edit_outlined,
            label: "Update Business Info",
            subtitle: "Keep your profile current",
            color: const Color(0xFF9B59B6),
            onTap: () {},
          ),

          const SizedBox(height: 12),

          _ActionButton(
            icon: Icons.bar_chart_outlined,
            label: "View Analytics",
            subtitle: "Detailed performance metrics",
            color: const Color(0xFFE74C3C),
            onTap: () {},
          ),

          const SizedBox(height: 12),

          _ActionButton(
            icon: Icons.message_outlined,
            label: "Message Investors",
            subtitle: "Send updates to shareholders",
            color: const Color(0xFF2ECC71),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
