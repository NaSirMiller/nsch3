import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/features/market/cubit/business_details_cubit.dart";
import "package:capital_commons/features/user/user_cubit.dart";
import "package:capital_commons/utils/snackbar_message.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "../widgets/business_hero.dart";
import "../widgets/business_stats.dart";
import "../widgets/share_purchase_card.dart";
import "../widgets/business_about.dart";
import "../widgets/financials_section.dart";

class BusinessDetailPage extends HookWidget {
  const BusinessDetailPage({super.key, required this.businessId});

  final String businessId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return BlocProvider(
      create: (_) => BusinessDetailsCubit()..loadBusiness(businessId),
      child: BlocConsumer<BusinessDetailsCubit, BusinessDetailsState>(
        listener: (context, state) {
          // Handle load business failure
          if (state.message != null) {
            context.showSnackbarMessage(state.message!);
          }
        },
        builder: (context, state) {
          if (state.loadBusinessStatus.isLoading) {
            return Scaffold(
              appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4A90D9)),
                ),
              ),
            );
          }

          if (state.loadBusinessStatus.isFailure || state.business == null) {
            return Scaffold(
              appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
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
                child: const Center(
                  child: Text(
                    "Couldn't load business details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          }

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
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    // Back button
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          color: Colors.white70,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border),
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    // Content
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Hero section
                          BusinessHero(
                            name: state.business!.name,
                            category: state.business!.industry,
                            location: state.business!.address,
                            logo: Icons.image_not_supported,
                            verified: true,
                            founded: state.business!.yearFounded,
                          ),

                          const SizedBox(height: 24),

                          // Stats
                          BusinessStats(
                            price: state.business!.sharePrice,
                            raised: state.business!.amountRaised as double,
                            goal: state.business!.goal,
                            investors: state.business!.numInvestors,
                            dividend: state.business!.dividendPercentage,
                          ),

                          const SizedBox(height: 24),

                          // Two column layout for desktop
                          if (isDesktop)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      BusinessAbout(
                                        description:
                                            state.business!.description,
                                      ),
                                      const SizedBox(height: 24),
                                      FinancialsSection(
                                        revenue:
                                            state.business!.projectedRevenue,
                                        expenses:
                                            state.business!.projectedExpenses,
                                        netProfit:
                                            state.business!.projectedProfit,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: SharePurchaseCard(
                                    price: state.business!.sharePrice,
                                    sharesAvailable:
                                        state.business!.sharesAvailable,
                                    dividend:
                                        state.business!.dividendPercentage,
                                    businessId: businessId,
                                    isPurchasing:
                                        state.purchaseStatus.isLoading,
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            // Stacked for mobile/tablet
                            SharePurchaseCard(
                              price: state.business!.sharePrice,
                              sharesAvailable: state.business!.sharesAvailable,
                              dividend: state.business!.dividendPercentage,
                              businessId: businessId,
                              isPurchasing: state.purchaseStatus.isLoading,
                            ),
                            const SizedBox(height: 24),
                            BusinessAbout(
                              description: state.business!.description,
                            ),
                            const SizedBox(height: 24),
                            FinancialsSection(
                              revenue: state.business!.projectedRevenue,
                              expenses: state.business!.projectedExpenses,
                              netProfit: state.business!.projectedProfit,
                            ),
                          ],

                          const SizedBox(height: 40),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
