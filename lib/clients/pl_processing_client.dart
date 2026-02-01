import "package:capital_commons/models/pl_processing_result.dart";
import "package:cloud_functions/cloud_functions.dart";

class PlProcessingClientException implements Exception {
  const PlProcessingClientException([
    this.message = "An unexpected error occurred",
  ]);
  final String message;
}

class PlProcessingClient {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<PlProcessingResult> processPlFile(String plFilePath) async {
    try {
      final result = await _functions
          .httpsCallable("get_revenue_and_expenses_from_pl_statement")
          .call({"pl_statement_path": plFilePath});

      final data = result.data;

      if (data is! Map<String, dynamic>) {
        throw const PlProcessingClientException(
          "Invalid response format from PL processing service",
        );
      }

      // Handle error payloads returned as 200s
      if (data.containsKey("status") && data["status"] != 200) {
        throw PlProcessingClientException(
          data["error"]?.toString() ?? "PL processing failed",
        );
      }

      return PlProcessingResult.fromJson(data);
    } on FirebaseFunctionsException catch (e) {
      throw PlProcessingClientException(
        e.message ?? "Failed to process P&L statement",
      );
    } catch (e) {
      throw const PlProcessingClientException();
    }
  }
}
