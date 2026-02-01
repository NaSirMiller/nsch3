import "package:flutter/material.dart";
import "shared/stage_title.dart";
import "shared/input_field.dart";
import "shared/dropdown_field.dart";
import "shared/action_button.dart";

class Stage2BusinessInfo extends StatelessWidget {
  const Stage2BusinessInfo({
    super.key,
    required this.onNext,
    required this.businessNameController,
    required this.descriptionController,
    required this.addressController,
    required this.yearController,
    required this.selectedType,
  });

  final VoidCallback onNext;
  final TextEditingController businessNameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final TextEditingController yearController;
  final ValueNotifier<String?> selectedType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StageTitle(
          title: "Business Information",
          subtitle: "Tell us about your business",
        ),
        const SizedBox(height: 32),

        InputField(
          controller: businessNameController,
          label: "Business Name",
          icon: Icons.business_outlined,
        ),

        const SizedBox(height: 16),

        InputField(
          controller: descriptionController,
          label: "Business Description",
          icon: Icons.description_outlined,
          maxLines: 4,
        ),

        const SizedBox(height: 16),

        InputField(
          controller: addressController,
          label: "Business Address (Capital Region)",
          icon: Icons.location_on_outlined,
        ),

        const SizedBox(height: 16),

        DropdownField(
          value: selectedType.value,
          label: "Business Type",
          items: const [
            "LLC",
            "Corporation",
            "Sole Proprietorship",
            "Partnership",
          ],
          onChanged: (value) => selectedType.value = value,
        ),

        const SizedBox(height: 16),

        InputField(
          controller: yearController,
          label: "Year Founded",
          icon: Icons.calendar_today_outlined,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 32),

        ActionButton(label: "Continue", onPressed: onNext),
      ],
    );
  }
}
