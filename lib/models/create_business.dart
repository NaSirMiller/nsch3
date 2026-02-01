import "package:freezed_annotation/freezed_annotation.dart";

part "create_business.freezed.dart";
part "create_business.g.dart";

@freezed
sealed class CreateBusiness with _$CreateBusiness {
  const factory CreateBusiness({
    required String uid,
    required String name,
    required String description,
    required String industry,
    required String logoFilepath,
    required String plDocFilepath,
    required double projectedRevenue,
    required double projectedExpenses,
    required double projectedProfit,
    required double valuation,
    required int totalSharesIssued,
    required double sharePrice,
    required double dividendPercentage,
    required bool isApproved,
    required String address,
  }) = _CreateBusiness;

  factory CreateBusiness.fromJson(Map<String, dynamic> json) =>
      _$CreateBusinessFromJson(json);
}
