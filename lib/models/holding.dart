import "package:freezed_annotation/freezed_annotation.dart";

part "holding.freezed.dart";
part "holding.g.dart";

@freezed
sealed class Holding with _$Holding {
  const factory Holding({
    required String ticker,
    required double sharePrice,
    required int shareCount,
  }) = _Holding;

  factory Holding.fromJson(Map<String, dynamic> json) =>
      _$HoldingFromJson(json);
}
