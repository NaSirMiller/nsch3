import "package:freezed_annotation/freezed_annotation.dart";

part "pl_processing_result.freezed.dart";
part "pl_processing_result.g.dart";

@freezed
sealed class PlProcessingResult with _$PlProcessingResult {
  const factory PlProcessingResult({
    @JsonKey(name: "total_revenue") required double totalRevenue,
    @JsonKey(name: "total_expenses") required double totalExpenses,
  }) = _PlProcessingResult;

  factory PlProcessingResult.fromJson(Map<String, dynamic> json) =>
      _$PlProcessingResultFromJson(json);
}
