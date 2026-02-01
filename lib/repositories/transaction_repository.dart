// lib/repositories/transaction_repository.dart
import "package:capital_commons/core/logger.dart";
import "package:capital_commons/models/transaction.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class TransactionRepositoryException implements Exception {
  const TransactionRepositoryException([
    this.message = "An unexpected error occurred",
  ]);

  final String message;
}

const _transactionsCollectionName = "transactions";

class TransactionRepository {
  final _firestore = FirebaseFirestore.instance;

  /// Get recent transactions by user ID (either as fromUser or toUser)
  Future<List<TransactionModel>> getRecentTransactionsByUserId(
    String userId, {
    int limit = 10,
  }) async {
    Log.trace("Getting recent transactions for user $userId with limit $limit");

    try {
      // Get transactions where user is either sender or receiver
      final fromUserQuery = await _firestore
          .collection(_transactionsCollectionName)
          .where("fromUser", isEqualTo: userId)
          .orderBy("timestamp", descending: true)
          .limit(limit)
          .get();

      final toUserQuery = await _firestore
          .collection(_transactionsCollectionName)
          .where("toUser", isEqualTo: userId)
          .orderBy("timestamp", descending: true)
          .limit(limit)
          .get();

      final transactions = <TransactionModel>[];

      // Process fromUser transactions
      for (final doc in fromUserQuery.docs) {
        try {
          final data = doc.data();
          if (!data.containsKey('uid')) {
            data['uid'] = doc.id;
          }
          transactions.add(TransactionModel.fromJson(data));
        } catch (e) {
          Log.warning("Error parsing transaction: $e");
        }
      }

      // Process toUser transactions
      for (final doc in toUserQuery.docs) {
        try {
          final data = doc.data();
          if (!data.containsKey('uid')) {
            data['uid'] = doc.id;
          }
          // Avoid duplicates
          if (!transactions.any((t) => t.uid == data['uid'])) {
            transactions.add(TransactionModel.fromJson(data));
          }
        } catch (e) {
          Log.warning("Error parsing transaction: $e");
        }
      }

      // Sort by timestamp descending and limit
      transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final limitedTransactions = transactions.take(limit).toList();

      Log.debug(
        "Loaded ${limitedTransactions.length} transactions for user $userId",
      );
      return limitedTransactions;
    } on FirebaseException catch (e) {
      Log.error(
        "FirebaseException occurred while getting transactions for user $userId: $e",
      );
      throw const TransactionRepositoryException(
        "A FirebaseException occurred",
      );
    }
  }

  /// Get all transactions for a specific business
  Future<List<TransactionModel>> getTransactionsByBusinessId(
    String businessId, {
    int limit = 50,
  }) async {
    Log.trace("Getting transactions for business $businessId");

    try {
      final results = await _firestore
          .collection(_transactionsCollectionName)
          .where("businessId", isEqualTo: businessId)
          .orderBy("timestamp", descending: true)
          .limit(limit)
          .get();

      final transactions = <TransactionModel>[];
      for (final doc in results.docs) {
        try {
          final data = doc.data();
          if (!data.containsKey('uid')) {
            data['uid'] = doc.id;
          }
          transactions.add(TransactionModel.fromJson(data));
        } catch (e) {
          Log.warning("Error parsing transaction: $e");
        }
      }

      Log.debug(
        "Loaded ${transactions.length} transactions for business $businessId",
      );
      return transactions;
    } on FirebaseException catch (e) {
      Log.error(
        "FirebaseException occurred while getting transactions for business $businessId: $e",
      );
      throw const TransactionRepositoryException(
        "A FirebaseException occurred",
      );
    }
  }

  /// Create a new transaction
  Future<void> createTransaction(TransactionModel transaction) async {
    Log.trace("Creating transaction ${transaction.uid}");

    try {
      await _firestore
          .collection(_transactionsCollectionName)
          .doc(transaction.uid)
          .set(transaction.toJson());

      Log.debug("Successfully created transaction ${transaction.uid}");
    } on FirebaseException catch (e) {
      Log.error("FirebaseException occurred while creating transaction: $e");
      throw const TransactionRepositoryException(
        "A FirebaseException occurred",
      );
    }
  }

  /// Get transaction by ID
  Future<TransactionModel?> getTransactionById(String transactionId) async {
    Log.trace("Getting transaction $transactionId");

    try {
      final doc = await _firestore
          .collection(_transactionsCollectionName)
          .doc(transactionId)
          .get();

      if (!doc.exists) {
        Log.trace("Transaction $transactionId not found");
        return null;
      }

      final data = doc.data()!;
      if (!data.containsKey('uid')) {
        data['uid'] = doc.id;
      }

      return TransactionModel.fromJson(data);
    } on FirebaseException catch (e) {
      Log.error(
        "FirebaseException occurred while getting transaction $transactionId: $e",
      );
      throw const TransactionRepositoryException(
        "A FirebaseException occurred",
      );
    }
  }
}
