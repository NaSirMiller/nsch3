// features/market/views/secondary_market_page.dart
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "../widgets/share_listing_card.dart";
import "../widgets/market_type_toggle.dart";
import "../widgets/filter_chip_row.dart";
import "../widgets/search_bar.dart" as market;

class SecondaryMarketPage extends HookWidget {
  const SecondaryMarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    final searchController = useTextEditingController();
    final selectedCategory = useState<String?>(null);

    // Mock secondary market listings
    final listings = [
      {
        "id": "1",
        "businessName": "Capital Coffee Co.",
        "businessId": "1",
        "seller": "Alice Johnson",
        "shares": 50,
        "pricePerShare": 130.0,
        "originalPrice": 125.0,
        "listedDate": "2 days ago",
        "logo": Icons.local_cafe,
        "category": "Food & Beverage",
      },
      {
        "id": "2",
        "businessName": "Troy Tech Solutions",
        "businessId": "2",
        "seller": "Bob Smith",
        "shares": 25,
        "pricePerShare": 210.0,
        "originalPrice": 200.0,
        "listedDate": "5 hours ago",
        "logo": Icons.computer,
        "category": "Technology",
      },
      {
        "id": "3",
        "businessName": "Green Energy Co.",
        "businessId": "6",
        "seller": "Carol White",
        "shares": 100,
        "pricePerShare": 245.0,
        "originalPrice": 250.0,
        "listedDate": "1 day ago",
        "logo": Icons.energy_savings_leaf,
        "category": "Energy",
      },
    ];

    int getCrossAxisCount() {
      if (isDesktop) return 3;
      if (isTablet) return 2;
      return 1;
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
              // App bar
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () => context.go("/market"),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
                title: const Text(
                  "Secondary Market",
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

              // Header
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
                  vertical: 16,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Buy Shares from Other Investors",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${listings.length} listings available",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Market type toggle
                      MarketTypeToggle(
                        selectedType: MarketType.secondary,
                        onTypeChanged: (type) {
                          if (type == MarketType.primary) {
                            context.go("/market");
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

              // Listings grid
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 40 : (isTablet ? 24 : 16),
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(),
                    childAspectRatio: isDesktop ? 0.9 : (isTablet ? 0.85 : 0.8),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final listing = listings[index];
                    return ShareListingCard(
                      businessName: listing["businessName"] as String,
                      seller: listing["seller"] as String,
                      shares: listing["shares"] as int,
                      pricePerShare: listing["pricePerShare"] as double,
                      originalPrice: listing["originalPrice"] as double,
                      listedDate: listing["listedDate"] as String,
                      logo: listing["logo"] as IconData,
                      category: listing["category"] as String,
                      onTap: () {
                        context.push("/market/secondary/${listing["id"]}");
                      },
                    );
                  }, childCount: listings.length),
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
            ],
          ),
        ),
      ),
    );
  }
}
