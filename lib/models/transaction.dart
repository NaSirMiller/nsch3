import "package:cloud_firestore/cloud_firestore.dart";

class TransactionModel {
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    // Handle timestamp conversion from Firestore
    DateTime timestamp;
    if (json["timestamp"] is Timestamp) {
      timestamp = (json["timestamp"] as Timestamp).toDate();
    } else if (json["timestamp"] is String) {
      timestamp = DateTime.parse(json["timestamp"]);
    } else {
      timestamp = DateTime.now();
    }

    return TransactionModel(
      uid: json["uid"] ?? "",
      fromUser: json["fromUser"] ?? "",
      toUser: json["toUser"] ?? "",
      numShares: json["numShares"] ?? 0,
      isProcessed: json["isProcessed"] ?? false,
      timestamp: timestamp,
      pricePerShare: (json["pricePerShare"] as num?)?.toDouble() ?? 0.0,
    );
  }

  TransactionModel({
    required this.uid,
    required this.fromUser,
    required this.toUser,
    required this.numShares,
    required this.isProcessed,
    required this.timestamp,
    required this.pricePerShare,
  });

  final String uid;
  final String fromUser;
  final String toUser;
  final int numShares;
  final bool isProcessed;
  final DateTime timestamp;
  final double pricePerShare;

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "fromUser": fromUser,
      "toUser": toUser,
      "numShares": numShares,
      "isProcessed": isProcessed,
      "timestamp": Timestamp.fromDate(timestamp),
      "pricePerShare": pricePerShare,
    };
  }
}
