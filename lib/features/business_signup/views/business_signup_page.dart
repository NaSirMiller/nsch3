import "package:capital_commons/features/business_signup/cubit/business_signup_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "package:capital_commons/features/business_signup/widgets/stage_progress.dart";
import "package:capital_commons/features/business_signup/widgets/stage_1_account.dart";
import "package:capital_commons/features/business_signup/widgets/stage_2_business_info.dart";
import "package:capital_commons/features/business_signup/widgets/stage_3_financials.dart";
import "package:capital_commons/features/business_signup/widgets/stage_4_valuation.dart";
import "package:capital_commons/features/business_signup/widgets/stage_5_shares.dart";
import "package:capital_commons/features/business_signup/widgets/stage_6_legal.dart";
import "package:capital_commons/features/business_signup/widgets/stage_7_complete.dart";
import "package:capital_commons/features/business_signup/widgets/shared/glow_circle.dart";

class BusinessSignupPage extends HookWidget {
  const BusinessSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentStage = useState(0);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDesktop = screenWidth >= 1024;

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final businessNameController = useTextEditingController();
    final addressController = useTextEditingController();
    final yearController = useTextEditingController();
    final selectedType = useState<String?>(null);
    final revenueController = useTextEditingController();
    final expensesController = useTextEditingController();
    final netProfitController = useTextEditingController();
    final selectedPeriod = useState<String?>(null);
    final totalSharesController = useTextEditingController(text: "1000");
    final pricePerShareController = useTextEditingController(text: "100");
    final dividendController = useTextEditingController(text: "5");
    final agreedToTerms = useState(false);

    final stages = [
      "Account",
      "Business Info",
      "Financials",
      "Valuation",
      "Shares",
      "Legal",
      "Complete",
    ];

    void nextStage() {
      if (currentStage.value < stages.length - 1) {
        currentStage.value++;
      }
    }

    void previousStage() {
      if (currentStage.value > 0) {
        currentStage.value--;
      }
    }

    return BlocProvider(
      create: (_) => BusinessSignupCubit(),
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A1628), Color(0xFF1A2E4A), Color(0xFF0D3B66)],
            ),
          ),
          child: Stack(
            children: [
              // Background glow
              Positioned(
                top: -80,
                right: -60,
                child: GlowCircle(
                  size: 250,
                  color: const Color(0xFF4A90D9).withOpacity(0.08),
                ),
              ),

              // Back button
              Positioned(
                top: 56,
                left: 20,
                child: IconButton(
                  onPressed: () {
                    if (currentStage.value > 0) {
                      previousStage();
                    } else {
                      context.go("/signup");
                    }
                  },
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
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 800 : 600,
                      ),
                      child: Column(
                        children: [
                          // Progress indicator
                          StageProgress(
                            currentStage: currentStage.value,
                            stages: stages,
                          ),

                          const SizedBox(height: 40),

                          // Stage content card
                          Container(
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
                            child: Builder(
                              builder: (context) {
                                return _buildStageContent(
                                  context: context,
                                  stage: currentStage.value,
                                  onNext: nextStage,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                  businessNameController:
                                      businessNameController,
                                  addressController: addressController,
                                  yearController: yearController,
                                  selectedType: selectedType,
                                  revenueController: revenueController,
                                  expensesController: expensesController,
                                  netProfitController: netProfitController,
                                  selectedPeriod: selectedPeriod,
                                  totalSharesController: totalSharesController,
                                  pricePerShareController:
                                      pricePerShareController,
                                  dividendController: dividendController,
                                  agreedToTerms: agreedToTerms,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageContent({
    required BuildContext context,
    required int stage,
    required VoidCallback onNext,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController businessNameController,
    required TextEditingController addressController,
    required TextEditingController yearController,
    required ValueNotifier<String?> selectedType,
    required TextEditingController revenueController,
    required TextEditingController expensesController,
    required TextEditingController netProfitController,
    required ValueNotifier<String?> selectedPeriod,
    required TextEditingController totalSharesController,
    required TextEditingController pricePerShareController,
    required TextEditingController dividendController,
    required ValueNotifier<bool> agreedToTerms,
  }) {
    switch (stage) {
      case 0:
        return Stage1Account(
          onNext: onNext,
          emailController: emailController,
          passwordController: passwordController,
        );
      case 1:
        return Stage2BusinessInfo(
          onNext: onNext,
          businessNameController: businessNameController,
          addressController: addressController,
          yearController: yearController,
          selectedType: selectedType,
        );
      case 2:
        return Stage3Financials(
          onNext: onNext,
          revenueController: revenueController,
          expensesController: expensesController,
          netProfitController: netProfitController,
          selectedPeriod: selectedPeriod,
        );
      case 3:
        return Stage4Valuation(onNext: onNext);
      case 4:
        return Stage5Shares(
          onNext: onNext,
          totalSharesController: totalSharesController,
          pricePerShareController: pricePerShareController,
          dividendController: dividendController,
        );
      case 5:
        return Stage6Legal(
          onNext: () {
            onNext();
            context.read<BusinessSignupCubit>().submitForm(
              email: emailController.text,
              password: passwordController.text,
              businessName: businessNameController.text,
              address: addressController.text,
              year: yearController.text,
              selectedType: selectedType.value,
              revenue: revenueController.text,
              expenses: expensesController.text,
              netProfit: netProfitController.text,
              selectedPeriod: selectedPeriod.value,
              totalShares: totalSharesController.text,
              pricePerShare: pricePerShareController.text,
              dividend: dividendController.text,
              agreedToTerms: agreedToTerms.value,
            );
          },
          agreedToTerms: agreedToTerms,
        );
      case 6:
        return const Stage7Complete();
      default:
        return const SizedBox();
    }
  }
}
