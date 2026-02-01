import "package:capital_commons/features/business_signup/cubit/business_signup_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "shared/stage_title.dart";
import "shared/file_upload_box.dart";
import "shared/action_button.dart";

class Stage3FinancialsUpload extends StatelessWidget {
  const Stage3FinancialsUpload({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StageTitle(
          title: "Financial Disclosure",
          subtitle: "Upload your P&L statement",
        ),
        const SizedBox(height: 32),

        BlocBuilder<BusinessSignupCubit, BusinessSignupState>(
          buildWhen: (prev, curr) => prev.plFilePath != curr.plFilePath,
          builder: (context, state) {
            return FileUploadBox(
              label: "Upload P&L Statement",
              subtitle: "PDF accepted",
              filePath: state.plFilePath,
              onPickFile: () {
                context.read<BusinessSignupCubit>().pickFile();
              },
              onRemoveFile: () {
                context.read<BusinessSignupCubit>().removePlFile();
              },
            );
          },
        ),

        const SizedBox(height: 32),

        ActionButton(label: "Continue", onPressed: onNext),
      ],
    );
  }
}
