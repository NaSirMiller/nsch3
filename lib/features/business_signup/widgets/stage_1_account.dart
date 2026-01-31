import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "shared/stage_title.dart";
import "shared/input_field.dart";
import "shared/action_button.dart";

class Stage1Account extends HookWidget {
  const Stage1Account({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const StageTitle(
          title: "Create Your Account",
          subtitle: "Set up your business account credentials",
        ),
        const SizedBox(height: 32),
        InputField(
          controller: emailController,
          label: "Email",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        InputField(
          controller: passwordController,
          label: "Password",
          icon: Icons.lock_outlined,
          obscureText: obscurePassword.value,
          suffixIcon: IconButton(
            onPressed: () => obscurePassword.value = !obscurePassword.value,
            icon: Icon(
              obscurePassword.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: Colors.white38,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 32),
        ActionButton(label: "Continue", onPressed: onNext),
      ],
    );
  }
}
