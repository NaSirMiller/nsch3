import "package:capital_commons/core/logger.dart";
import "package:capital_commons/models/business.dart";
import "package:capital_commons/models/create_business.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class BusinessRepositoryException implements Exception {
  const BusinessRepositoryException([
    this.message = "An unexpected error occurred",
  ]);
  final String message;
}

const _businessesCollectionName = "businesses";

class BusinessRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> createBusiness(CreateBusiness business) async {
    Log.trace("Creating business with id ${business.uid}");
    try {
      await _firestore
          .collection(_businessesCollectionName)
          .doc(business.uid)
          .set(business.toJson());
    } on FirebaseException catch (e) {
      Log.error(
        "FirebaseException occurred while creating business ${business.uid}: $e",
      );
      throw const BusinessRepositoryException("A FirebaseException occurred");
    }
  }

  Future<Business?> getBusinessById(String businessId) async {
    Log.trace("Fetching business with id $businessId");
    try {
      final doc = await _firestore
          .collection(_businessesCollectionName)
          .doc(businessId)
          .get();

      if (!doc.exists) {
        Log.trace("Business with id $businessId not found");
        return null;
      }

      return Business.fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      Log.error(
        "FirebaseException occurred while fetching business $businessId: $e",
      );
      throw const BusinessRepositoryException("A FirebaseException occurred");
    }
  }
}
