// features/market/widgets/market_type_toggle.dart
import "package:flutter/material.dart";

enum MarketType { primary, secondary }

class MarketTypeToggle extends StatelessWidget {
  const MarketTypeToggle({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  final MarketType selectedType;
  final ValueChanged<MarketType> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            label: "Primary Market",
            icon: Icons.business,
            isSelected: selectedType == MarketType.primary,
            onTap: () => onTypeChanged(MarketType.primary),
          ),
          const SizedBox(width: 4),
          _ToggleButton(
            label: "Secondary Market",
            icon: Icons.swap_horiz,
            isSelected: selectedType == MarketType.secondary,
            onTap: () => onTypeChanged(MarketType.secondary),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4A90D9).withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A90D9).withOpacity(0.5)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF4A90D9)
                  : Colors.white.withOpacity(0.6),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF4A90D9)
                    : Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
