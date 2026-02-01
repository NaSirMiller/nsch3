import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "shared/stage_title.dart";
import "shared/info_card.dart";
import "shared/action_button.dart";
import "../cubit/business_signup_cubit.dart";

class Stage4Valuation extends StatelessWidget {
  const Stage4Valuation({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessSignupCubit, BusinessSignupState>(
      builder: (context, state) {
        final valuation = state.valuation ?? 0;
        final fundingCap = state.fundingCap ?? 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StageTitle(
              title: "Platform Valuation",
              subtitle: "Review and accept your business valuation",
            ),
            const SizedBox(height: 32),

            InfoCard(
              title: "Suggested Valuation",
              value: "\$${valuation.toStringAsFixed(2)}",
              icon: Icons.monetization_on_outlined,
            ),
            const SizedBox(height: 16),

            InfoCard(
              title: "Funding Cap",
              value: "\$${fundingCap.toStringAsFixed(2)}",
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.amber, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Valuation: 10x net profit (\$${(state.netProfit ?? 0).toStringAsFixed(0)})\nFunding Cap: 40% of valuation",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            ActionButton(
              label: "Accept Valuation",
              onPressed: () {
                context.read<BusinessSignupCubit>().acceptValuation();
                onNext();
              },
            ),
            const SizedBox(height: 12),

            TextButton(
              onPressed: () {
                // TODO: Implement review request
              },
              child: const Text(
                "Request Review",
                style: TextStyle(color: Color(0xFF4A90D9)),
              ),
            ),
          ],
        );
      },
    );
  }
}
