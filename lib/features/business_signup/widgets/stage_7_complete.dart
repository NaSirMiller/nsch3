import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "shared/action_button.dart";

class Stage7Complete extends StatelessWidget {
  const Stage7Complete({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4A90D9).withOpacity(0.2),
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF4A90D9),
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Setup Complete!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "Your business is now listed on Capital Exchange.\nInvestors can start purchasing shares.",
          style: TextStyle(
            fontSize: 15,
            color: Colors.white.withOpacity(0.7),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ActionButton(
          label: "Go to Dashboard",
          onPressed: () => context.go("/business/dashboard"),
        ),
      ],
    );
  }
}
