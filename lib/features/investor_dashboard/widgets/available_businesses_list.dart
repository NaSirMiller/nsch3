import "package:capital_commons/repositories/business_repository.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:flutter/material.dart";
import "package:capital_commons/shared/dashboard_section.dart";
import "package:capital_commons/shared/investor_row.dart";
import "package:capital_commons/models/business.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class AvailableBusinessesList extends HookWidget {
  const AvailableBusinessesList({super.key});

  @override
  Widget build(BuildContext context) {
    final businessesState = useState<List<Business>>([]);
    final isLoading = useState(true);

    useEffect(() {
      Future<void> loadBusinesses() async {
        try {
          final repo = getIt<BusinessRepository>();
          final businesses = await repo.getApprovedBusinesses(limit: 5);
          businessesState.value = businesses;
        } catch (e) {
          // Handle error
          debugPrint("Error loading businesses: $e");
        } finally {
          isLoading.value = false;
        }
      }

      loadBusinesses();
      return null;
    }, []);

    if (isLoading.value) {
      return DashboardSection(
        title: "Available Businesses",
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: Color(0xFF4A90D9)),
        ),
      );
    }

    if (businessesState.value.isEmpty) {
      return DashboardSection(
        title: "Available Businesses",
        child: Container(
          height: 120,
          alignment: Alignment.center,
          child: Text(
            "No businesses available for investment",
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ),
      );
    }

    return DashboardSection(
      title: "Available Businesses",
      child: Column(
        children: [
          const SizedBox(height: 12),
          ...businessesState.value.map((business) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InvestorRow(
                name: business.name,
                shares: business.sharesAvailable,
                date: business.industry,
                amount: "\$${business.sharePrice.toStringAsFixed(2)}",
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
