import "package:capital_commons/models/holding.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class HoldingsRepositoryException implements Exception {
  const HoldingsRepositoryException([
    this.message = "An unexpected error occurred",
  ]);
  final String message;
}

const _portfoliosCollectionName = "portfolios";
const _holdingsCollectionName = "holdings";

class HoldingsRepository {
  final _firestore = FirebaseFirestore.instance;

  /// Fetch all holdings for a given investor
  Future<List<Holding>> getHoldingsByInvestorId(String investorId) async {
    try {
      final snapshot = await _firestore
          .collection(_portfoliosCollectionName)
          .doc(investorId)
          .collection(_holdingsCollectionName)
          .get();

      // Map each document to a Holding instance
      final holdings = snapshot.docs
          .map((doc) => Holding.fromJson(doc.data()))
          .toList();

      return holdings;
    } on FirebaseException catch (e) {
      throw HoldingsRepositoryException(
        "Failed to fetch holdings: ${e.message}",
      );
    } catch (e) {
      throw HoldingsRepositoryException("An unexpected error occurred: $e");
    }
  }
}
