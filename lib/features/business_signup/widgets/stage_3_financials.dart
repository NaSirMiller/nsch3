import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:capital_commons/features/business_signup/cubit/business_signup_cubit.dart";
import "shared/stage_title.dart";
import "shared/input_field.dart";
import "shared/dropdown_field.dart";
import "shared/action_button.dart";
import "package:capital_commons/core/loading_status.dart";

class Stage3Financials extends HookWidget {
  const Stage3Financials({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final revenueController = useTextEditingController();
    final expensesController = useTextEditingController();
    final netProfitController = useTextEditingController();
    final selectedPeriod = useState<String?>(null);

    return BlocConsumer<BusinessSignupCubit, BusinessSignupState>(
      listener: (context, state) {
        if (state.message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));
        }
      },
      builder: (context, state) {
        final isLoading = state.financialsStatus == LoadingStatus.loading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StageTitle(
              title: "Financial Disclosure",
              subtitle: "Provide summary of your financials",
            ),
            const SizedBox(height: 32),

            DropdownField(
              value: selectedPeriod.value,
              label: "Financial Period",
              items: const ["Last 12 months", "Forward-looking 12 months"],
              onChanged: (value) => selectedPeriod.value = value,
            ),
            const SizedBox(height: 16),

            InputField(
              controller: revenueController,
              label: "Total Revenue",
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            InputField(
              controller: expensesController,
              label: "Total Expenses",
              icon: Icons.money_off_outlined,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            InputField(
              controller: netProfitController,
              label: "Net Profit",
              icon: Icons.trending_up,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),

            ActionButton(
              label: isLoading ? "Processing..." : "Submit Financials",
              onPressed: isLoading
                  ? null
                  : () {
                      final revenue = revenueController.text;
                      final expenses = expensesController.text;
                      final netProfit = netProfitController.text;
                      final period = selectedPeriod.value;

                      if (revenue.isEmpty ||
                          expenses.isEmpty ||
                          netProfit.isEmpty ||
                          period == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill all financial fields"),
                          ),
                        );
                        return;
                      }

                      // Update financials in cubit
                      context.read<BusinessSignupCubit>().updateFinancials(
                        revenue: double.parse(revenue),
                        expenses: double.parse(expenses),
                        netProfit: double.parse(netProfit),
                        period: period,
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
