import "package:flutter/material.dart";
import "dart:html" as html;

class FileUploadBox extends StatelessWidget {
  const FileUploadBox({
    super.key,
    required this.label,
    required this.subtitle,
    required this.onPickFile,
    required this.onRemoveFile,
    this.filePath,
  });

  final String label;
  final String subtitle;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;
  final String? filePath;

  @override
  Widget build(BuildContext context) {
    final hasFile = filePath != null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: hasFile ? _UploadedFileView() : _EmptyUploadView(),
    );
  }

  Widget _EmptyUploadView() {
    return Column(
      children: [
        Icon(
          Icons.upload_file_outlined,
          color: Colors.white.withOpacity(0.5),
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5)),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onPickFile,
          icon: const Icon(Icons.add, size: 18),
          label: const Text("Choose File"),
        ),
      ],
    );
  }

  _UploadedFileView() {
    return Row(
      children: [
        const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 36),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (filePath != null) {
                html.window.open(filePath!, "_blank");
              }
            },
            child: Text(
              filePath!.split("/").last,
              style: const TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        IconButton(
          onPressed: onRemoveFile,
          icon: const Icon(Icons.close, color: Colors.white70),
        ),
      ],
    );
  }
}
