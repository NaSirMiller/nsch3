import "dart:io";
import "dart:typed_data";
import "package:capital_commons/core/logger.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:path/path.dart" as path;
import "package:uuid/uuid.dart";

class FileStorageClientException implements Exception {
  const FileStorageClientException([
    this.message = "An unexpected error occurred",
  ]);
  final String message;
}

class FileStorageClient {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  /// Uploads a file to Firebase Storage and returns the storage path
  Future<String> uploadBytes({
    required Uint8List bytes,
    required String folder,
    required String fileName,
  }) async {
    final storagePath = "$folder/$fileName";
    final ref = _storage.ref().child(storagePath);

    try {
      await ref.putData(
        bytes,
        SettableMetadata(contentType: "application/pdf"),
      );
      return storagePath;
    } on FirebaseException catch (e) {
      Log.error("FirebaseException uploading file: ${e.code} - ${e.message}");
      throw FileStorageClientException(
        e.message ?? "Failed to upload file to storage",
      );
    } catch (e, st) {
      Log.error("Exception uploading file: $e\n$st");
      throw const FileStorageClientException();
    }
  }
}
