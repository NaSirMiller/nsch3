import "package:freezed_annotation/freezed_annotation.dart";

part "business.freezed.dart";
part "business.g.dart";

@freezed
sealed class Business with _$Business {
  const factory Business({
    required String uid,
    required String name,
    required String description,
    required String industry,
    required String? logoFilepath,
    required String? plDocFilepath,
    required double projectedRevenue,
    required double projectedExpenses,
    required double projectedProfit,
    required double valuation,
    required int totalSharesIssued,
    required double sharePrice,
    required double dividendPercentage,
    required bool isApproved,
    required String address,
    required double goal,
    required int numInvestors,
    required int amountRaised,
    required String yearFounded,
    required int sharesAvailable,
    required String ticker,
  }) = _Business;

  factory Business.fromJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);
}
