import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:pdfx/pdfx.dart';

class PdfDoc {
  PdfController? _pdfController;
  Uint8List? _pdfBytes;

  PdfController? getPdfController() {
    return _pdfController;
  }

  void setPdf(Uint8List bytes) {
    if (bytes.isEmpty) return;
    _pdfBytes = bytes;
    _pdfController = PdfController(document: PdfDocument.openData(bytes));
  }

  Future<void> downloadPdf(String templateName) async {
    final Uint8List? currentBytes = _pdfBytes;

    if (currentBytes == null || currentBytes.isEmpty) {
      print("_pdfBytes vacio");
      return;
    }

    String fileName =
        "${templateName}_${DateTime.now().millisecondsSinceEpoch}";

    try {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: currentBytes,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );
      print("Download started for $fileName");
    } catch (e) {
      print("Error saving file: $e");
    }
  }

  void clear() {
    _pdfController = null;
    _pdfBytes = null;
  }
}
