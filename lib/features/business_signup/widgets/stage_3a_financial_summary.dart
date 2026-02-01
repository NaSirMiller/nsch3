import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/features/business_signup/cubit/business_signup_cubit.dart";
import "package:capital_commons/features/business_signup/widgets/shared/action_button.dart";
import "package:capital_commons/features/business_signup/widgets/shared/dropdown_field.dart";
import "package:capital_commons/features/business_signup/widgets/shared/input_field.dart";
import "package:capital_commons/features/business_signup/widgets/shared/stage_title.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class Stage3aFinancialSummary extends HookWidget {
  const Stage3aFinancialSummary({
    super.key,
    required this.onNext,
    required this.revenueController,
    required this.expensesController,
    required this.netProfitController,
    required this.selectedPeriod,
  });

  final VoidCallback onNext;
  final TextEditingController revenueController;
  final TextEditingController expensesController;
  final TextEditingController netProfitController;
  final ValueNotifier<String?> selectedPeriod;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessSignupCubit, BusinessSignupState>(
      builder: (context, state) {
        if (state.uploadAndProcessPlFileStatus.isLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StageTitle(
              title: "Financial Summary",
              subtitle: "Provide a high-level overview of your finances",
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
            ActionButton(label: "Submit Financials", onPressed: onNext),
          ],
        );
      },
    );
  }
}
