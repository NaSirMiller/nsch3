import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/features/investor_signup/cubit/investor_signup_cubit.dart";
import "package:capital_commons/utils/snackbar_message.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";

class InvestorSignupPage extends HookWidget {
  const InvestorSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return BlocProvider(
      create: (_) => InvestorSignupCubit(),
      child: BlocListener<InvestorSignupCubit, InvestorSignupState>(
        listener: (context, state) {
          if (state.signupStatus.isFailure) {
            context.showSnackbarMessage(
              state.message ?? "An unexpected error occurred",
            );
          }
          // Navigate to market page on success
          if (state.signupStatus.isSuccess) {
            context.go("/market");
          }
        },
        child: Builder(
          builder: (context) {
            return Scaffold(
              body: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0A1628),
                      Color(0xFF1A2E4A),
                      Color(0xFF0D3B66),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background glow effects
                    Positioned(
                      top: -80,
                      right: -60,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF4A90D9).withOpacity(0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -100,
                      left: -80,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF4A90D9).withOpacity(0.06),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Back button
                    Positioned(
                      top: 56,
                      left: 20,
                      child: IconButton(
                        onPressed: () => context.go("/signup"),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white70,
                          size: 22,
                        ),
                      ),
                    ),

                    // Main content
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 40,
                          ),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: Form(
                              key: formKey,
                              child: Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Icon
                                    Container(
                                      width: 64,
                                      height: 64,
                                      margin: const EdgeInsets.only(bottom: 24),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF4A90D9,
                                        ).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.person_outline_rounded,
                                        color: Color(0xFF4A90D9),
                                        size: 32,
                                      ),
                                    ),

                                    // Title
                                    const Text(
                                      "Create your investor account",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 12),

                                    // Subtitle
                                    Text(
                                      "Get access to exclusive investment opportunities",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.6),
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 40),

                                    // Email field
                                    TextFormField(
                                      controller: emailController,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.05,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF4A90D9),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 20),

                                    // Password field
                                    TextFormField(
                                      controller: passwordController,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.05,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF4A90D9),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      obscureText: true,
                                    ),
                                    const SizedBox(height: 32),

                                    // Submit button
                                    SizedBox(
                                      height: 56,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<InvestorSignupCubit>()
                                              .submitSignupForm(
                                                email: emailController.text
                                                    .trim(),
                                                password:
                                                    passwordController.text,
                                              );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF4A90D9,
                                          ),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          "Create account",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Terms text
                                    Text(
                                      "By signing up, you agree to our Terms & Privacy Policy",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.4),
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
