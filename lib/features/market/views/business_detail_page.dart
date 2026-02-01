import "package:capital_commons/core/loading_status.dart";
import "package:capital_commons/features/market/cubit/business_details_cubit.dart";
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

    // Mock business data (would come from API)
    final business = {
      "id": businessId,
      "name": "Capital Coffee Co.",
      "category": "Food & Beverage",
      "location": "123 River Street, Troy, NY 12180",
      "logo": Icons.local_cafe,
      "price": 125.0,
      "raised": 87500.0,
      "goal": 100000.0,
      "investors": 24,
      "dividend": 5.0,
      "verified": true,
      "founded": "2020",
      "description":
          "Capital Coffee Co. is an artisan coffee roastery dedicated to sourcing and roasting the finest beans from around the world. We serve the Capital Region with premium coffee and espresso drinks, while supporting local community initiatives and sustainable farming practices.",
      "revenue": 250000.0,
      "expenses": 180000.0,
      "netProfit": 70000.0,
      "sharesAvailable": 125,
      "totalShares": 1000,
    };

    return BlocProvider(
      create: (_) => BusinessDetailsCubit()..loadBusiness(businessId),
      child: BlocConsumer<BusinessDetailsCubit, BusinessDetailsState>(
        listener: (context, state) {
          if (state.message != null) {
            context.showSnackbarMessage(state.message!);
          }
        },
        builder: (context, state) {
          if (state.loadBusinessStatus.isLoading) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          if (state.loadBusinessStatus.isFailure) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text("Couldn't load business details")),
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
                            location: "Address not available", // TODO
                            logo: Icons.image_not_supported,
                            verified: true,
                            founded: "Year not available", // TODO
                          ),

                          const SizedBox(height: 24),

                          // Stats
                          BusinessStats(
                            price: business["price"] as double,
                            raised: business["raised"] as double,
                            goal: business["goal"] as double,
                            investors: business["investors"] as int,
                            dividend: business["dividend"] as double,
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
                                            business["description"] as String,
                                      ),
                                      const SizedBox(height: 24),
                                      FinancialsSection(
                                        revenue: business["revenue"] as double,
                                        expenses:
                                            business["expenses"] as double,
                                        netProfit:
                                            business["netProfit"] as double,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: SharePurchaseCard(
                                    price: business["price"] as double,
                                    sharesAvailable:
                                        business["sharesAvailable"] as int,
                                    dividend: business["dividend"] as double,
                                  ),
                                ),
                              ],
                            )
                          else ...[
                            // Stacked for mobile/tablet
                            SharePurchaseCard(
                              price: business["price"] as double,
                              sharesAvailable:
                                  business["sharesAvailable"] as int,
                              dividend: business["dividend"] as double,
                            ),
                            const SizedBox(height: 24),
                            BusinessAbout(
                              description: business["description"] as String,
                            ),
                            const SizedBox(height: 24),
                            FinancialsSection(
                              revenue: business["revenue"] as double,
                              expenses: business["expenses"] as double,
                              netProfit: business["netProfit"] as double,
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
