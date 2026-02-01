import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:capital_commons/features/business_signup/cubit/business_signup_cubit.dart";
import "shared/stage_title.dart";
import "shared/action_button.dart";

class Stage6Legal extends HookWidget {
  const Stage6Legal({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final agreedToTerms = useState(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StageTitle(
          title: "Legal Acknowledgment",
          subtitle: "Review and accept platform terms",
        ),
        const SizedBox(height: 32),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegalItem(
                icon: Icons.calendar_today_outlined,
                text: "Quarterly profit reporting required",
              ),
              SizedBox(height: 12),
              _LegalItem(
                icon: Icons.payment_outlined,
                text: "Dividend payouts within 30 days of reporting",
              ),
              SizedBox(height: 12),
              _LegalItem(
                icon: Icons.verified_user_outlined,
                text: "Platform rules and community guidelines",
              ),
              SizedBox(height: 12),
              _LegalItem(
                icon: Icons.account_balance_outlined,
                text: "Escrow management by Capital Exchange",
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Checkbox(
              value: agreedToTerms.value,
              onChanged: (value) => agreedToTerms.value = value ?? false,
              activeColor: const Color(0xFF4A90D9),
              side: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            Expanded(
              child: Text(
                "I agree to the terms and conditions",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        ActionButton(
          label: "Complete Setup",
          onPressed: agreedToTerms.value
              ? () async {
                  context.read<BusinessSignupCubit>().acceptTerms();
                  await context
                      .read<BusinessSignupCubit>()
                      .submitBusinessSignup();
                  onNext();
                }
              : null,
        ),
      ],
    );
  }
}

class _LegalItem extends StatelessWidget {
  const _LegalItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF4A90D9), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
      ],
    );
  }
}
