import "package:capital_commons/features/market/cubit/market_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "../widgets/business_card.dart";
import "../widgets/filter_chip_row.dart";
import "../widgets/market_type_toggle.dart";
import "../widgets/search_bar.dart" as market;

class MarketPage extends HookWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    final searchController = useTextEditingController();
    final selectedCategory = useState<String?>(null);

    // Mock business data
    final businesses = [
      {
        "id": "1",
        "name": "Capital Coffee Co.",
        "category": "Food & Beverage",
        "location": "Troy, NY",
        "logo": Icons.local_cafe,
        "price": 125.0,
        "raised": 87500.0,
        "goal": 100000.0,
        "investors": 24,
        "dividend": 5.0,
        "verified": true,
        "description": "Artisan coffee roastery serving the Capital Region",
      },
      {
        "id": "2",
        "name": "Troy Tech Solutions",
        "category": "Technology",
        "location": "Troy, NY",
        "logo": Icons.computer,
        "price": 200.0,
        "raised": 120000.0,
        "goal": 150000.0,
        "investors": 45,
        "dividend": 7.0,
        "verified": true,
        "description": "Software development and IT consulting firm",
      },
      {
        "id": "3",
        "name": "Hudson Valley Bakery",
        "category": "Food & Beverage",
        "location": "Albany, NY",
        "logo": Icons.bakery_dining,
        "price": 75.0,
        "raised": 45000.0,
        "goal": 75000.0,
        "investors": 18,
        "dividend": 4.5,
        "verified": true,
        "description": "Fresh-baked goods using local ingredients",
      },
      {
        "id": "4",
        "name": "Capital Fitness",
        "category": "Health & Wellness",
        "location": "Schenectady, NY",
        "logo": Icons.fitness_center,
        "price": 100.0,
        "raised": 60000.0,
        "goal": 100000.0,
        "investors": 32,
        "dividend": 6.0,
        "verified": false,
        "description": "Modern gym with personal training services",
      },
      {
        "id": "5",
        "name": "Saratoga Crafts",
        "category": "Retail",
        "location": "Saratoga Springs, NY",
        "logo": Icons.shopping_bag,
        "price": 150.0,
        "raised": 90000.0,
        "goal": 120000.0,
        "investors": 28,
        "dividend": 5.5,
        "verified": true,
        "description": "Handmade crafts and local artisan goods",
      },
      {
        "id": "6",
        "name": "Green Energy Co.",
        "category": "Energy",
        "location": "Albany, NY",
        "logo": Icons.energy_savings_leaf,
        "price": 250.0,
        "raised": 180000.0,
        "goal": 200000.0,
        "investors": 52,
        "dividend": 8.0,
        "verified": true,
        "description": "Solar panel installation and energy consulting",
      },
    ];

    // Calculate grid crossAxisCount
    int getCrossAxisCount() {
      if (isDesktop) return 3;
      if (isTablet) return 2;
      return 1;
    }

    return BlocProvider(
      create: (_) => MarketCubit()..loadBusinesses(),
      child: BlocBuilder<MarketCubit, MarketState>(
        builder: (context, state) {
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
                    // App bar
                    SliverAppBar(
                      floating: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: const Text(
                        "Marketplace",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.white70,
                        ),
                        IconButton(
                          onPressed: () {
                            context.push("/investor/dashboard");
                          },
                          icon: const Icon(Icons.person_outline),
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),

                    // Search and filters
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
                        vertical: 16,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header text
                            const Text(
                              "Invest in Capital Region Businesses",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${businesses.length} businesses available",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Market type toggle
                            MarketTypeToggle(
                              selectedType: MarketType.primary,
                              onTypeChanged: (type) {
                                if (type == MarketType.secondary) {
                                  context.push("/market/secondary");
                                }
                              },
                            ),

                            const SizedBox(height: 24),

                            // Search bar
                            market.SearchBar(controller: searchController),
                            const SizedBox(height: 16),

                            // Filter chips
                            FilterChipRow(
                              selectedCategory: selectedCategory.value,
                              onCategorySelected: (category) {
                                selectedCategory.value = category;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Business grid
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: getCrossAxisCount(),
                          childAspectRatio: isDesktop
                              ? 0.85
                              : (isTablet ? 0.8 : 0.75),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final business = state.businesses[index];
                          return BusinessCard(
                            name: business.name,
                            category: business.industry,
                            location: "Address not available", // TODO
                            logo: Icons.image_not_supported,
                            price: business.sharePrice,
                            raised: 0.0, // TODO
                            goal: 0.0, // TODO
                            investors: 0, // TODO
                            dividend: business.dividendPercentage,
                            verified: true, // TODO
                            onTap: () {
                              context.push("/market/${business.uid}");
                            },
                          );
                        }, childCount: state.businesses.length),
                      ),
                    ),

                    const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
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
// import "package:capital_commons/features/market/cubit/market_cubit.dart";
// import "package:flutter/material.dart";
// import "package:flutter_bloc/flutter_bloc.dart";
// import "package:flutter_hooks/flutter_hooks.dart";
// import "package:go_router/go_router.dart";
// import "../widgets/business_card.dart";
// import "../widgets/filter_chip_row.dart";
// import "../widgets/market_type_toggle.dart";
// import "../widgets/search_bar.dart" as market;

// class MarketPage extends HookWidget {
//   const MarketPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isDesktop = screenWidth >= 1024;
//     final isTablet = screenWidth >= 768 && screenWidth < 1024;

//     final searchController = useTextEditingController();
//     final selectedCategory = useState<String?>(null);

//     // Mock business data
//     final businesses = [
//       {
//         "id": "1",
//         "name": "Capital Coffee Co.",
//         "category": "Food & Beverage",
//         "location": "Troy, NY",
//         "logo": Icons.local_cafe,
//         "price": 125.0,
//         "raised": 87500.0,
//         "goal": 100000.0,
//         "investors": 24,
//         "dividend": 5.0,
//         "verified": true,
//         "description": "Artisan coffee roastery serving the Capital Region",
//       },
//       {
//         "id": "2",
//         "name": "Troy Tech Solutions",
//         "category": "Technology",
//         "location": "Troy, NY",
//         "logo": Icons.computer,
//         "price": 200.0,
//         "raised": 120000.0,
//         "goal": 150000.0,
//         "investors": 45,
//         "dividend": 7.0,
//         "verified": true,
//         "description": "Software development and IT consulting firm",
//       },
//       {
//         "id": "3",
//         "name": "Hudson Valley Bakery",
//         "category": "Food & Beverage",
//         "location": "Albany, NY",
//         "logo": Icons.bakery_dining,
//         "price": 75.0,
//         "raised": 45000.0,
//         "goal": 75000.0,
//         "investors": 18,
//         "dividend": 4.5,
//         "verified": true,
//         "description": "Fresh-baked goods using local ingredients",
//       },
//       {
//         "id": "4",
//         "name": "Capital Fitness",
//         "category": "Health & Wellness",
//         "location": "Schenectady, NY",
//         "logo": Icons.fitness_center,
//         "price": 100.0,
//         "raised": 60000.0,
//         "goal": 100000.0,
//         "investors": 32,
//         "dividend": 6.0,
//         "verified": false,
//         "description": "Modern gym with personal training services",
//       },
//       {
//         "id": "5",
//         "name": "Saratoga Crafts",
//         "category": "Retail",
//         "location": "Saratoga Springs, NY",
//         "logo": Icons.shopping_bag,
//         "price": 150.0,
//         "raised": 90000.0,
//         "goal": 120000.0,
//         "investors": 28,
//         "dividend": 5.5,
//         "verified": true,
//         "description": "Handmade crafts and local artisan goods",
//       },
//       {
//         "id": "6",
//         "name": "Green Energy Co.",
//         "category": "Energy",
//         "location": "Albany, NY",
//         "logo": Icons.energy_savings_leaf,
//         "price": 250.0,
//         "raised": 180000.0,
//         "goal": 200000.0,
//         "investors": 52,
//         "dividend": 8.0,
//         "verified": true,
//         "description": "Solar panel installation and energy consulting",
//       },
//     ];

//     // Calculate grid crossAxisCount
//     int getCrossAxisCount() {
//       if (isDesktop) return 3;
//       if (isTablet) return 2;
//       return 1;
//     }

//     return BlocProvider(
//       create: (_) => MarketCubit()..loadBusinesses(),
//       child: BlocBuilder<MarketCubit, MarketState>(
//         builder: (context, state) {
//           return Scaffold(
//             body: DecoratedBox(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     Color(0xFF0A1628),
//                     Color(0xFF1A2E4A),
//                     Color(0xFF0D3B66),
//                   ],
//                 ),
//               ),
//               child: SafeArea(
//                 child: CustomScrollView(
//                   slivers: [
//                     // App bar
//                     SliverAppBar(
//                       floating: true,
//                       backgroundColor: Colors.transparent,
//                       elevation: 0,
//                       title: const Text(
//                         "Marketplace",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       actions: [
//                         IconButton(
//                           onPressed: () {},
//                           icon: const Icon(Icons.notifications_outlined),
//                           color: Colors.white70,
//                         ),
//                         IconButton(
//                           onPressed: () {
//                             context.push("/investor/dashboard");
//                           },
//                           icon: const Icon(Icons.person_outline),
//                           color: Colors.white70,
//                         ),

//                         const SizedBox(width: 8),
//                       ],
//                     ),

//                     // Search and filters
//                     SliverPadding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
//                         vertical: 16,
//                       ),
//                       sliver: SliverToBoxAdapter(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Header text
//                             const Text(
//                               "Invest in Capital Region Businesses",
//                               style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               "${state.businesses.length} businesses available",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Colors.white.withOpacity(0.6),
//                               ),
//                             ),
//                             const SizedBox(height: 24),

//                             // Search bar
//                             market.SearchBar(controller: searchController),
//                             const SizedBox(height: 16),

//                             // Filter chips
//                             FilterChipRow(
//                               selectedCategory: selectedCategory.value,
//                               onCategorySelected: (category) {
//                                 selectedCategory.value = category;
//                               },
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 20),

//                       // Market type toggle
//                       MarketTypeToggle(
//                         selectedType: MarketType.primary,
//                         onTypeChanged: (type) {
//                           if (type == MarketType.secondary) {
//                             context.push("/market/secondary");
//                           }
//                         },
//                       ),

//                       const SizedBox(height: 24),

//                     // Business grid
//                     SliverPadding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
//                       ),
//                       sliver: SliverGrid(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: getCrossAxisCount(),
//                           childAspectRatio: isDesktop
//                               ? 0.85
//                               : (isTablet ? 0.8 : 0.75),
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                         ),
//                         delegate: SliverChildBuilderDelegate((context, index) {
//                           final business = state.businesses[index];
//                           return BusinessCard(
//                             name: business.name,
//                             category: business.industry,
//                             location: "Address not available", // TODO
//                             logo: Icons.image_not_supported,
//                             price: business.sharePrice,
//                             raised: 0.0, // TODO
//                             goal: 0.0, // TODO
//                             investors: 0, // TODO
//                             dividend: business.dividendPercentage,
//                             verified: true, // TODO
//                             onTap: () {
//                               context.push("/market/${business.uid}");
//                             },
//                           );
//                         }, childCount: state.businesses.length),
//                       ),
//                     ),

//                     const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
