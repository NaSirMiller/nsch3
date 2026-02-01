import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/features/market/cubit/business_details_cubit.dart";
import "package:capital_commons/features/user/user_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class SharePurchaseCard extends HookWidget {
  const SharePurchaseCard({
    super.key,
    required this.price,
    required this.sharesAvailable,
    required this.dividend,
    required this.businessId,
    this.isPurchasing = false,
  });

  final double price;
  final int sharesAvailable;
  final double dividend;
  final String businessId;
  final bool isPurchasing;

  @override
  Widget build(BuildContext context) {
    final numShares = useState(1);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          const Text(
            "Purchase Shares",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Price per share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Price per share",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Text(
                "\$${price.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Number of shares selector
          Text(
            "Number of shares",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (numShares.value > 1) {
                    numShares.value--;
                  }
                },
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.white70,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    "${numShares.value}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  numShares.value++;
                },
                icon: const Icon(Icons.add_circle_outline),
                color: Colors.white70,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Total cost
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4A90D9).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total cost",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "\$${(price * numShares.value).toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A90D9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Expected annual dividend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Expected annual dividend",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Text(
                "\$${((price * numShares.value * dividend) / 100).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2ECC71),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Purchase button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: isPurchasing
                  ? null
                  : () {
                      // Get current user ID
                      final userId = getIt<UserCubit>().state.currentUser?.uid;

                      if (userId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please log in to purchase shares"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Call purchase
                      context.read<BusinessDetailsCubit>().purchaseShares(
                        investorId: userId,
                        numShares: numShares.value,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90D9),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(
                  0xFF4A90D9,
                ).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: isPurchasing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Purchase Shares",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
