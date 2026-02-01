import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "shared/stage_title.dart";
import "shared/input_field.dart";
import "shared/action_button.dart";

class Stage5Shares extends HookWidget {
  const Stage5Shares({
    super.key,
    required this.onNext,
    required this.totalSharesController,
    required this.pricePerShareController,
    required this.dividendController,
  });

  final VoidCallback onNext;
  final TextEditingController totalSharesController;
  final TextEditingController pricePerShareController;
  final TextEditingController dividendController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StageTitle(
          title: "Share Issuance Setup",
          subtitle: "Configure your tradable shares",
        ),
        const SizedBox(height: 32),
        InputField(
          controller: totalSharesController,
          label: "Total Shares",
          icon: Icons.pie_chart_outline,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        InputField(
          controller: pricePerShareController,
          label: "Price Per Share (\$)",
          icon: Icons.attach_money,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        InputField(
          controller: dividendController,
          label: "Dividend Percentage (%)",
          icon: Icons.percent,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4A90D9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4A90D9).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Preview",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "If profit = \$50,000 → Investor payout = \$2,500",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        ActionButton(label: "Create Shares", onPressed: onNext),
      ],
    );
  }
}
