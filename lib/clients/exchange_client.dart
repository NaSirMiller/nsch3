import "package:cloud_functions/cloud_functions.dart";
import "package:capital_commons/core/logger.dart";

class ExchangeClientException implements Exception {
  final String message;
  ExchangeClientException(this.message);

  @override
  String toString() => "ExchangeClientException: $message";
}

class ExchangeClient {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Exchange shares from business to investor
  Future<void> exchangeBusinessToInvestor({
    required String businessId,
    required String investorId,
    required int numShares,
  }) async {
    try {
      Log.info("=== Starting exchange_business_to_investor ===");
      Log.info("Business ID: $businessId");
      Log.info("Investor ID: $investorId");
      Log.info("Number of shares: $numShares");

      final callable = _functions.httpsCallable(
        "exchange_business_to_investor",
      );

      Log.info("Calling Cloud Function...");

      // For callable functions, the response is directly in result.data
      final result = await callable.call({
        "business_id": businessId,
        "investor_id": investorId,
        "num_shares": numShares,
      });

      Log.info("Cloud Function response received");
      Log.info("Result data: ${result.data}");

      final data = result.data as Map<String, dynamic>?;

      if (data == null) {
        Log.error("Result data is null");
        throw ExchangeClientException("No response data received");
      }

      final status = data["status"] as int?;
      final message = data["message"] as String?;

      Log.info("Status: $status");
      Log.info("Message: $message");

      if (status != 200) {
        final error = message ?? "Unknown error";
        Log.error("Exchange failed: $error");
        throw ExchangeClientException(error);
      }

      Log.info("Exchange completed successfully");
      Log.info("=== End exchange_business_to_investor ===");
    } on FirebaseFunctionsException catch (e) {
      Log.error("=== FirebaseFunctionsException ===");
      Log.error("Code: ${e.code}");
      Log.error("Message: ${e.message}");
      Log.error("Details: ${e.details}");

      // Map error codes to user-friendly messages
      String errorMessage;
      switch (e.code) {
        case "unauthenticated":
          errorMessage = "Please log in to purchase shares";
          break;
        case "permission-denied":
          errorMessage = "You don't have permission to perform this action";
          break;
        case "not-found":
          errorMessage = "Business or investor not found";
          break;
        case "resource-exhausted":
          errorMessage = "Not enough shares available";
          break;
        case "invalid-argument":
          errorMessage = e.message ?? "Invalid request parameters";
          break;
        case "internal":
          errorMessage = e.message ?? "Server error occurred";
          break;
        default:
          errorMessage = e.message ?? "Failed to exchange shares";
      }

      throw ExchangeClientException(errorMessage);
    } on ExchangeClientException {
      rethrow;
    } catch (e, stackTrace) {
      Log.error("=== Unexpected error ===");
      Log.error("Error type: ${e.runtimeType}");
      Log.error("Error: $e");
      Log.error("Stack trace: $stackTrace");
      throw ExchangeClientException("An unexpected error occurred: $e");
    }
  }
}
