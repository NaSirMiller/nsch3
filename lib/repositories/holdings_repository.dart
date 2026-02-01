import "package:capital_commons/core/logger.dart";
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
    Log.trace("Fetching holdings for investor $investorId");

    try {
      final snapshot = await _firestore
          .collection(_portfoliosCollectionName)
          .doc(investorId)
          .collection(_holdingsCollectionName)
          .get();

      final holdings = <Holding>[];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          // Add document ID if not present
          if (!data.containsKey('uid')) {
            data['uid'] = doc.id;
          }
          holdings.add(Holding.fromJson(data));
        } catch (e) {
          Log.warning("Error parsing holding document ${doc.id}: $e");
        }
      }

      Log.debug("Loaded ${holdings.length} holdings for investor $investorId");
      return holdings;
    } on FirebaseException catch (e) {
      Log.error("FirebaseException while fetching holdings: ${e.message}");
      throw HoldingsRepositoryException(
        "Failed to fetch holdings: ${e.message}",
      );
    } catch (e, st) {
      Log.error("Unexpected error fetching holdings", error: e, stackTrace: st);
      throw HoldingsRepositoryException("An unexpected error occurred: $e");
    }
  }
}
