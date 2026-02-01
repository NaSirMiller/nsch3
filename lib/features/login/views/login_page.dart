import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:capital_commons/features/login/cubit/login_cubit.dart";
import "package:capital_commons/features/login/cubit/login_state.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoadingStatus.success) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar(); // hides any previous SnackBar

            // TO DO: MODIFY ROUTE BASED ON USER TYPE
            context.go("/investor/dashboard");


          } else if (state.status == LoadingStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar() // hides any previous SnackBar
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "Login failed"),
                backgroundColor: Colors.redAccent,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == LoadingStatus.loading;

          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    Color(0xFF0A1628),
                    Color(0xFF1A2E4A),
                    Color(0xFF0D3B66),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // background glow circles
                  Positioned(
                    top: -80,
                    right: -60,
                    child: _GlowCircle(
                      size: 250,
                      color: const Color(0xFF4A90D9).withOpacity(0.08),
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.15,
                    left: -100,
                    child: _GlowCircle(
                      size: 300,
                      color: const Color(0xFF2ECC71).withOpacity(0.06),
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.4,
                    right: -40,
                    child: _GlowCircle(
                      size: 180,
                      color: const Color(0xFF4A90D9).withOpacity(0.05),
                    ),
                  ),

                  // back button
                  Positioned(
                    top: 56,
                    left: 20,
                    child: IconButton(
                      onPressed: () => context.go("/"),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white70,
                        size: 22,
                      ),
                    ),
                  ),

                  // main content with card
                  Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop ? 480 : (isTablet ? 440 : 400),
                          ),
                          child: _LoginCard(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            obscurePassword: _obscurePassword,
                            isLoading: isLoading,
                            onObscureToggle: () {
                              setState(() =>
                                  _obscurePassword = !_obscurePassword);
                            },
                            onLogin: () {
                              context.read<LoginCubit>().login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                            },
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
    );
  }
}

// ─── Login Card ──────────────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onObscureToggle;
  final VoidCallback onLogin;

  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onObscureToggle,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // logo mark
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4A90D9).withOpacity(0.4),
                width: 2,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [Color(0xFF1A3A5C), Color(0xFF0D2137)],
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF4A90D9),
                size: 30,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // title
          const Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 8),

          // subtitle
          const Text(
            "Sign in to your Capital Exchange account",
            style: TextStyle(
              fontSize: 14,
              color: Color(0x99FFFFFF),
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // email field
          _InputField(
            controller: emailController,
            label: "Email",
            icon: Icons.email_outlined,
          ),

          const SizedBox(height: 16),

          // password field
          _InputField(
            controller: passwordController,
            label: "Password",
            icon: Icons.lock_outlined,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              onPressed: onObscureToggle,
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.white38,
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: forgot password flow
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
              ),
              child: const Text(
                "Forgot password?",
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4A90D9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // login button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color(0xFF4A90D9).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 24),

          // OR divider
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "OR",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // sign up redirect
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(fontSize: 14, color: Color(0x99FFFFFF)),
              ),
              TextButton(
                onPressed: () => context.go("/signup"),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A90D9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Input Field ─────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final Widget? suffixIcon;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: InputBorder.none,
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.35),
            fontSize: 15,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(icon, color: Colors.white38, size: 20),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

// ─── Glow Circle ─────────────────────────────────────────────────────────────

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
