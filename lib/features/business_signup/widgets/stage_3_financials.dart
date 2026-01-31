import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "shared/stage_title.dart";
import "shared/input_field.dart";
import "shared/dropdown_field.dart";
import "shared/file_upload_box.dart";
import "shared/action_button.dart";

class Stage3Financials extends HookWidget {
  const Stage3Financials({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final revenueController = useTextEditingController();
    final expensesController = useTextEditingController();
    final netProfitController = useTextEditingController();
    final selectedPeriod = useState<String?>(null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StageTitle(
          title: "Financial Disclosure",
          subtitle: "Upload your P&L statement and provide summary",
        ),
        const SizedBox(height: 32),
        const FileUploadBox(
          label: "Upload P&L Statement",
          subtitle: "PDF, XLS, or CSV accepted",
        ),
        const SizedBox(height: 24),
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
  }
}
