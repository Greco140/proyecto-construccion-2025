import 'dart:typed_data';
import 'package:dynadoc_front/viewmodels/template_fields.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/models/template_repository.dart';

class TemplateListViewModel extends ChangeNotifier {
  final TemplateRepository _repository = TemplateRepository();

  Template? _selectedTemplate;
  PdfController? _pdfController;
  bool _isLoading = false;
  final TemplateFields _templateFields = TemplateFields();

  Template? get selectedTemplate => _selectedTemplate;
  PdfController? get pdfController => _pdfController;
  bool get isLoading => _isLoading;
  TemplateFields get templateFields => _templateFields;

  Future<List<Template>> getTemplateList() => _repository.getTemplateList();

  void selectTemplate(Template template) {
    _selectedTemplate = template;
    _templateFields.clear();
    _pdfController = null;

    List<String> rawFields = List<String>.from(
      template.fields.map((f) => f.getName()),
    );

    _templateFields.generateFields(rawFields);

    notifyListeners();
  }

  List<Map<String, TextEditingController>> getLoopRows(String sectionName) {
    return _templateFields.getLoopRows(sectionName);
  }

  void addLoopRow(String sectionName, List<String> childFields) {
    _templateFields.addLoopRow(sectionName, childFields);
    notifyListeners();
  }

  void removeLoopRow(String sectionName, int index) {
    _templateFields.removeLoopRow(sectionName, index);
    notifyListeners();
  }

  Future<void> generateDocument() async {
    if (_selectedTemplate == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, Object> data = _templateFields.getFieldsAsMap();

      final Uint8List? pdfBytes = await _repository.generateDocument(
        _selectedTemplate!.name,
        data,
      );

      if (pdfBytes != null) {
        _pdfController = PdfController(
          document: PdfDocument.openData(pdfBytes),
        );
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
