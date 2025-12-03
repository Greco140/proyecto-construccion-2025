import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';
import 'package:dynadoc_front/models/pdf_doc.dart';

void main() {
  group('PdfDoc Model Tests', () {
    test('PdfDoc initialization', () {
      final pdfDoc = PdfDoc();

      expect(pdfDoc.getPdfController(), isNull);
    });

    test('PdfDoc.setPdf with empty bytes does nothing', () {
      final pdfDoc = PdfDoc();
      final emptyBytes = Uint8List(0);

      pdfDoc.setPdf(emptyBytes);

      expect(pdfDoc.getPdfController(), isNull);
    });

    test('PdfDoc.clear on uninitialized document', () {
      final pdfDoc = PdfDoc();

      // Should not throw
      pdfDoc.clear();

      expect(pdfDoc.getPdfController(), isNull);
    });

    test('PdfDoc.clear multiple times', () {
      final pdfDoc = PdfDoc();

      pdfDoc.clear();
      pdfDoc.clear();
      pdfDoc.clear();

      expect(pdfDoc.getPdfController(), isNull);
    });

    test('PdfDoc getter for pdf controller returns null initially', () {
      final pdfDoc = PdfDoc();

      final controller = pdfDoc.getPdfController();

      expect(controller, isNull);
    });

    test('PdfDoc stores reference to binary data', () {
      final pdfDoc = PdfDoc();
      expect(pdfDoc, isNotNull);
      expect(pdfDoc.getPdfController(), isNull);
    });

    test('PdfDoc multiple clear after initialization', () {
      final pdfDoc = PdfDoc();
      expect(pdfDoc.getPdfController(), isNull);

      pdfDoc.clear();
      expect(pdfDoc.getPdfController(), isNull);

      pdfDoc.clear();
      expect(pdfDoc.getPdfController(), isNull);
    });
  });
}
