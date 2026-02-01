import "package:freezed_annotation/freezed_annotation.dart";
import "package:cloud_firestore/cloud_firestore.dart";

part "holding.freezed.dart";
part "holding.g.dart";

@freezed
sealed class Holding with _$Holding {
  const factory Holding({
    String? uid,
    String? investorId,
    String? businessId,
    String? businessName,
    String? ticker,
    @Default(0) int numShares,
    @Default(0.0) double sharePrice,
    @Default(0.0) double totalInvested,
    @Default(0.0) double currentValue,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Holding;

  factory Holding.fromJson(Map<String, dynamic> json) =>
      _$HoldingFromJson(json);
}

// Timestamp converter for Freezed
class TimestampConverter implements JsonConverter<DateTime?, dynamic> {
  const TimestampConverter();

  @override
  DateTime? fromJson(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? date) {
    if (date == null) return null;
    return Timestamp.fromDate(date);
  }
}
