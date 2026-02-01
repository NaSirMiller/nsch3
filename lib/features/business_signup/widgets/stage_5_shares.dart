import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:capital_commons/features/business_signup/cubit/business_signup_cubit.dart";
import "shared/stage_title.dart";
import "shared/input_field.dart";
import "shared/action_button.dart";

class Stage5Shares extends HookWidget {
  const Stage5Shares({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final totalSharesController = useTextEditingController(text: "1000");
    final sharesToIssueController = useTextEditingController(text: "400");
    final dividendController = useTextEditingController(text: "5");
    final sharesToIssue = useState<double>(400);

    // Update text field when slider changes
    useEffect(() {
      sharesToIssueController.text = sharesToIssue.value.toInt().toString();
      return null;
    }, [sharesToIssue.value]);

    // Listen to text field changes
    useEffect(() {
      void listener() {
        final parsed = double.tryParse(sharesToIssueController.text);
        final maxShares = int.tryParse(totalSharesController.text) ?? 1000;
        if (parsed != null &&
            parsed <= maxShares &&
            parsed != sharesToIssue.value) {
          sharesToIssue.value = parsed;
        }
      }

      sharesToIssueController.addListener(listener);
      return () => sharesToIssueController.removeListener(listener);
    }, []);

    return BlocBuilder<BusinessSignupCubit, BusinessSignupState>(
      builder: (context, state) {
        final valuation = state.valuation ?? 0;
        final maxShares = int.tryParse(totalSharesController.text) ?? 1000;
        final pricePerShare = valuation / maxShares;
        final fundingGoal = pricePerShare * sharesToIssue.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StageTitle(
              title: "Share Issuance Setup",
              subtitle: "Configure your tradable shares",
            ),
            const SizedBox(height: 24),

            // Valuation reminder
            Container(
              padding: const EdgeInsets.all(20),
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
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        color: const Color(0xFF4A90D9),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Your Business Valuation",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "\$${valuation.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4A90D9),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Total shares (fixed)
            InputField(
              controller: totalSharesController,
              label: "Total Shares",
              icon: Icons.pie_chart_outline,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "Maximum shares for your business",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Shares to issue (slider + input)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.sell_outlined,
                        color: const Color(0xFF2ECC71),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Shares to Issue",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Input field
                  InputField(
                    controller: sharesToIssueController,
                    label: "Number of shares to offer",
                    icon: Icons.trending_up,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  // Slider
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFF2ECC71),
                      inactiveTrackColor: Colors.white.withOpacity(0.1),
                      thumbColor: const Color(0xFF2ECC71),
                      overlayColor: const Color(0xFF2ECC71).withOpacity(0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: sharesToIssue.value.clamp(0, maxShares.toDouble()),
                      min: 0,
                      max: maxShares.toDouble(),
                      divisions: maxShares,
                      onChanged: (value) {
                        sharesToIssue.value = value;
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Range indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        "$maxShares max",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Percentage indicator
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2ECC71).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Offering ${((sharesToIssue.value / maxShares) * 100).toStringAsFixed(1)}% ownership",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          "You retain ${(100 - (sharesToIssue.value / maxShares) * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Dividend percentage
            InputField(
              controller: dividendController,
              label: "Dividend Percentage (%)",
              icon: Icons.percent,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),

            // Calculations preview
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF4A90D9).withOpacity(0.15),
                    const Color(0xFF2ECC71).withOpacity(0.15),
                  ],
                ),
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
                    "Summary",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _SummaryRow(
                    label: "Price per share",
                    value: "\$${pricePerShare.toStringAsFixed(2)}",
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: "Shares to issue",
                    value: "${sharesToIssue.value.toInt()}",
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: "Funding goal",
                    value: "\$${fundingGoal.toStringAsFixed(2)}",
                    highlight: true,
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.white.withOpacity(0.1)),
                  const SizedBox(height: 12),
                  Text(
                    "Example: If profit = \$50,000 with ${dividendController.text}% dividend\n→ Total payout = \$${(50000 * (double.tryParse(dividendController.text) ?? 5) / 100).toStringAsFixed(0)}\n→ Per share = \$${((50000 * (double.tryParse(dividendController.text) ?? 5) / 100) / maxShares).toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            ActionButton(
              label: "Create Shares",
              onPressed: () {
                if (totalSharesController.text.isEmpty ||
                    sharesToIssueController.text.isEmpty ||
                    dividendController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields")),
                  );
                  return;
                }

                final totalShares = int.tryParse(totalSharesController.text);
                final issuedShares = int.tryParse(sharesToIssueController.text);

                if (totalShares == null || issuedShares == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Invalid number format")),
                  );
                  return;
                }

                if (issuedShares > totalShares) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Shares to issue cannot exceed total shares",
                      ),
                    ),
                  );
                  return;
                }

                context.read<BusinessSignupCubit>().updateShares(
                  totalShares: totalShares,
                  pricePerShare: pricePerShare,
                  dividend: double.parse(dividendController.text),
                );
                onNext();
              },
            ),
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: highlight ? 18 : 15,
            fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
            color: highlight ? const Color(0xFF2ECC71) : Colors.white,
          ),
        ),
      ],
    );
  }
}
