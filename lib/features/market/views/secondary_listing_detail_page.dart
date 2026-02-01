import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:go_router/go_router.dart";
import "../widgets/shared/investment_button.dart";

class SecondaryListingDetailPage extends HookWidget {
  const SecondaryListingDetailPage({super.key, required this.listingId});

  final String listingId;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // Mock listing data (would come from API based on listingId)
    final listing = {
      "id": listingId,
      "businessName": "Capital Coffee Co.",
      "businessId": "1",
      "seller": "Alice Johnson",
      "sellerAvatar": "AJ",
      "shares": 50,
      "pricePerShare": 130.0,
      "originalPrice": 125.0,
      "purchaseDate": "January 15, 2025",
      "listedDate": "2 days ago",
      "logo": Icons.local_cafe,
      "category": "Food & Beverage",
      "location": "Troy, NY",
      "verified": true,
      "reason": "Diversifying my portfolio to invest in tech sector",
      "businessRevenue": 250000.0,
      "businessProfit": 70000.0,
      "dividend": 5.0,
      "totalInvestors": 24,
    };

    final priceChange =
        (listing["pricePerShare"] as double) -
        (listing["originalPrice"] as double);
    final priceChangePercent =
        (priceChange / (listing["originalPrice"] as double)) * 100;
    final isProfit = priceChange > 0;
    final totalValue =
        (listing["shares"] as int) * (listing["pricePerShare"] as double);

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
                    // Listing header
                    _ListingHeader(
                      businessName: listing["businessName"] as String,
                      category: listing["category"] as String,
                      location: listing["location"] as String,
                      logo: listing["logo"] as IconData,
                      verified: listing["verified"] as bool,
                    ),

                    const SizedBox(height: 24),

                    // Price and stats
                    _PriceStats(
                      pricePerShare: listing["pricePerShare"] as double,
                      originalPrice: listing["originalPrice"] as double,
                      shares: listing["shares"] as int,
                      isProfit: isProfit,
                      priceChangePercent: priceChangePercent,
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
                                _SellerInfo(
                                  seller: listing["seller"] as String,
                                  sellerAvatar:
                                      listing["sellerAvatar"] as String,
                                  purchaseDate:
                                      listing["purchaseDate"] as String,
                                  reason: listing["reason"] as String,
                                ),
                                const SizedBox(height: 24),
                                _BusinessInfo(
                                  revenue: listing["businessRevenue"] as double,
                                  profit: listing["businessProfit"] as double,
                                  dividend: listing["dividend"] as double,
                                  investors: listing["totalInvestors"] as int,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: _PurchaseCard(
                              pricePerShare: listing["pricePerShare"] as double,
                              shares: listing["shares"] as int,
                              dividend: listing["dividend"] as double,
                            ),
                          ),
                        ],
                      )
                    else ...[
                      // Stacked for mobile/tablet
                      _PurchaseCard(
                        pricePerShare: listing["pricePerShare"] as double,
                        shares: listing["shares"] as int,
                        dividend: listing["dividend"] as double,
                      ),
                      const SizedBox(height: 24),
                      _SellerInfo(
                        seller: listing["seller"] as String,
                        sellerAvatar: listing["sellerAvatar"] as String,
                        purchaseDate: listing["purchaseDate"] as String,
                        reason: listing["reason"] as String,
                      ),
                      const SizedBox(height: 24),
                      _BusinessInfo(
                        revenue: listing["businessRevenue"] as double,
                        profit: listing["businessProfit"] as double,
                        dividend: listing["dividend"] as double,
                        investors: listing["totalInvestors"] as int,
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
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LISTING HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _ListingHeader extends StatelessWidget {
  const _ListingHeader({
    required this.businessName,
    required this.category,
    required this.location,
    required this.logo,
    required this.verified,
  });

  final String businessName;
  final String category;
  final String location;
  final IconData logo;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF4A90D9).withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(logo, color: const Color(0xFF4A90D9), size: 32),
          ),

          const SizedBox(width: 16),

          // Business info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        businessName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (verified) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF2ECC71),
                        size: 20,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9B59B6).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: const Color(0xFF9B59B6).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    "Secondary Market Listing",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9B59B6),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PRICE STATS
// ═══════════════════════════════════════════════════════════════════════════

class _PriceStats extends StatelessWidget {
  const _PriceStats({
    required this.pricePerShare,
    required this.originalPrice,
    required this.shares,
    required this.isProfit,
    required this.priceChangePercent,
  });

  final double pricePerShare;
  final double originalPrice;
  final int shares;
  final bool isProfit;
  final double priceChangePercent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.attach_money,
            label: "Asking Price",
            value: "\$${pricePerShare.toStringAsFixed(0)}",
            subtitle: "per share",
            color: const Color(0xFF4A90D9),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.pie_chart_outline,
            label: "Total Shares",
            value: shares.toString(),
            subtitle: "available",
            color: const Color(0xFF9B59B6),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: isProfit ? Icons.trending_up : Icons.trending_down,
            label: "Price Change",
            value:
                "${isProfit ? '+' : ''}${priceChangePercent.toStringAsFixed(1)}%",
            subtitle: "from \$${originalPrice.toStringAsFixed(0)}",
            color: isProfit ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SELLER INFO
// ═══════════════════════════════════════════════════════════════════════════

class _SellerInfo extends StatelessWidget {
  const _SellerInfo({
    required this.seller,
    required this.sellerAvatar,
    required this.purchaseDate,
    required this.reason,
  });

  final String seller;
  final String sellerAvatar;
  final String purchaseDate;
  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90D9).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF4A90D9),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Seller Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF4A90D9).withOpacity(0.3),
                child: Text(
                  sellerAvatar,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A90D9),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    seller,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Original purchase: $purchaseDate",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reason for Selling",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reason,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BUSINESS INFO
// ═══════════════════════════════════════════════════════════════════════════

class _BusinessInfo extends StatelessWidget {
  const _BusinessInfo({
    required this.revenue,
    required this.profit,
    required this.dividend,
    required this.investors,
  });

  final double revenue;
  final double profit;
  final double dividend;
  final int investors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2ECC71).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.business_outlined,
                  color: Color(0xFF2ECC71),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Business Performance",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(
            label: "Annual Revenue",
            value: "\$${revenue.toStringAsFixed(0)}",
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: "Net Profit",
            value: "\$${profit.toStringAsFixed(0)}",
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: "Dividend Rate",
            value: "${dividend.toStringAsFixed(1)}%",
          ),
          const SizedBox(height: 12),
          _InfoRow(label: "Total Investors", value: investors.toString()),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PURCHASE CARD
// ═══════════════════════════════════════════════════════════════════════════

class _PurchaseCard extends HookWidget {
  const _PurchaseCard({
    required this.pricePerShare,
    required this.shares,
    required this.dividend,
  });

  final double pricePerShare;
  final int shares;
  final double dividend;

  @override
  Widget build(BuildContext context) {
    final shareCount = useState(1);
    final maxShares = shares;
    final totalCost = pricePerShare * shareCount.value;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Purchase Shares",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Share count selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Number of Shares",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: shareCount.value > 1
                          ? () => shareCount.value--
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                      color: shareCount.value > 1
                          ? const Color(0xFF4A90D9)
                          : Colors.white.withOpacity(0.3),
                    ),
                    Expanded(
                      child: Text(
                        shareCount.value.toString(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: shareCount.value < maxShares
                          ? () => shareCount.value++
                          : null,
                      icon: const Icon(Icons.add_circle_outline),
                      color: shareCount.value < maxShares
                          ? const Color(0xFF4A90D9)
                          : Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "$maxShares shares available",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Cost breakdown
          _DetailRow(
            label: "Price per share",
            value: "\$${pricePerShare.toStringAsFixed(2)}",
          ),
          const SizedBox(height: 8),
          _DetailRow(label: "Shares", value: "× ${shareCount.value}"),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 12),
          _DetailRow(
            label: "Total Cost",
            value: "\$${totalCost.toStringAsFixed(2)}",
            isTotal: true,
          ),

          const SizedBox(height: 20),

          // Expected dividend
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF4A90D9).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF4A90D9),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Expected ${dividend.toStringAsFixed(1)}% annual dividend",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Buy button
          InvestmentButton(
            label: "Buy Shares",
            onPressed: () {
              // TODO: Handle purchase
            },
          ),

          const SizedBox(height: 12),

          Center(
            child: Text(
              "Secure payment via escrow",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: Colors.white.withOpacity(isTotal ? 0.9 : 0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 15,
            fontWeight: FontWeight.w700,
            color: isTotal ? const Color(0xFF2ECC71) : Colors.white,
          ),
        ),
      ],
    );
  }
}
