import 'dart:typed_data';
import 'package:dynadoc_front/models/pdf_doc.dart';
import 'package:dynadoc_front/viewmodels/dashboard_components/template_fields_list.dart';
import 'package:flutter/material.dart';
import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/models/template_list.dart';
import 'package:pdfx/pdfx.dart';

class TemplateListViewModel extends ChangeNotifier {
  final TemplateList _templateList = TemplateList();
  final PdfDoc _pdfDoc = PdfDoc();
  final TemplateFieldsList _templateFields = TemplateFieldsList();
  Template? _selectedTemplate;
  bool _isLoading = false;

  //getters
  Future<List<Template>> getTemplateList() => _templateList.getTemplateList();
  Template? get selectedTemplate => _selectedTemplate;
  bool get isLoading => _isLoading;
  TemplateFieldsList get templateFields => _templateFields;
  PdfController? get pdfController => _pdfDoc.getPdfController();

  void selectTemplate(Template template) {
    clear();

    List<String> rawFields = List<String>.from(
      template.fields.map((f) => f.getName()),
    );

    _templateFields.generateFields(rawFields);
    _selectedTemplate = template;

    notifyListeners();
  }

  List<Map<String, TextEditingController>> getLoopRows(String sectionName) {
    return _templateFields.getLoopRows(sectionName);
  }

  void addLoopRow(String sectionName, List<String> childFields) {
    _templateFields.addDynamicRow(sectionName, childFields);
    notifyListeners();
  }

  void removeLoopRow(String sectionName, int index) {
    _templateFields.removeDynamicRow(sectionName, index);
    notifyListeners();
  }

  Future<void> generateDocument() async {
    if (_selectedTemplate == null) return;
    _isLoading = true;
    _pdfDoc.clear();
    notifyListeners();
    //Obtenemos datos de la plantilla y generamos documento
    try {
      Map<String, Object> data = _templateFields.getFieldsAsMap();

      final Uint8List? pdfBytes = await _templateList.generateDocument(
        _selectedTemplate!.name,
        data,
      );
      //Guardamos pdf en el modelo
      if (pdfBytes != null) {
        _pdfDoc.setPdf(pdfBytes);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTemplate(Template template) async {
    bool result = await _templateList.deleteTemplate(template);
    clear();
    notifyListeners();
    return result;
  }

  void clear() {
    _selectedTemplate = null;
    _templateFields.clear();
    _pdfDoc.clear();
  }

  Future<void> downloadPdf() async {
    await generateDocument();
    await _pdfDoc.downloadPdf(_selectedTemplate!.name);
  }
}
