import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:capital_commons/features/business_signup/cubit/business_signup_cubit.dart";
import "shared/stage_title.dart";
import "shared/input_field.dart";
import "shared/dropdown_field.dart";
import "shared/action_button.dart";

class Stage2BusinessInfo extends HookWidget {
  const Stage2BusinessInfo({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final businessNameController = useTextEditingController();
    final addressController = useTextEditingController();
    final yearController = useTextEditingController();
    final selectedType = useState<String?>(null);

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
          controller: addressController,
          label: "Business Address (Capital Region)",
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 16),

        DropdownField(
          value: selectedType.value,
          label: "Business Type",
          items: const [
            "Food & Beverage",
            "Technology",
            "Health & Wellness",
            "Retail",
            "Energy",
            "Other",
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

        ActionButton(
          label: "Continue",
          onPressed: () {
            if (businessNameController.text.isEmpty ||
                addressController.text.isEmpty ||
                selectedType.value == null ||
                yearController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please fill all fields")),
              );
              return;
            }

            context.read<BusinessSignupCubit>().updateBusinessInfo(
              name: businessNameController.text,
              address: addressController.text,
              type: selectedType.value!,
              yearFounded: yearController.text,
            );
            onNext();
          },
        ),
      ],
    );
  }
}
