import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/models/template_repository.dart';

// (Paste the FormSection class here or import it)

// Helper class to define the structure of your form
class FormSection {
  final String name; // "productos"
  final bool isLoop; // true if it started with #
  final List<String> children; // ["nombre", "precio"]

  FormSection({
    required this.name,
    this.isLoop = false,
    this.children = const [],
  });
}

class TemplateListViewModel extends ChangeNotifier {
  final TemplateRepository _repository = TemplateRepository();

  Template? _selectedTemplate;
  PdfController? _pdfController;
  bool _isLoading = false;

  // 1. Structure for the UI (Parsed from the flat list)
  List<FormSection> _formStructure = [];

  // 2. Controllers for Simple Fields (e.g., "cliente")
  final Map<String, TextEditingController> _simpleControllers = {};

  // 3. Controllers for Loops (e.g., "productos" -> List of Rows -> "nombre": Controller)
  // Map<SectionName, List<RowMap>>
  final Map<String, List<Map<String, TextEditingController>>> _loopControllers =
      {};

  // Getters
  Template? get selectedTemplate => _selectedTemplate;
  PdfController? get pdfController => _pdfController;
  bool get isLoading => _isLoading;
  List<FormSection> get formStructure => _formStructure;

  // Accessors for the View
  TextEditingController? getSimpleController(String name) =>
      _simpleControllers[name];

  List<Map<String, TextEditingController>> getLoopRows(String sectionName) {
    return _loopControllers[sectionName] ?? [];
  }

  Future<List<Template>> getTemplateList() => _repository.getTemplateList();

  // --- PARSING LOGIC ---
  void selectTemplate(Template template) {
    _selectedTemplate = template;
    _formStructure.clear();
    _simpleControllers.clear();
    _loopControllers.clear();
    _pdfController = null;

    List<String> rawFields = List<String>.from(
      template.fields.map((f) => f.getName()),
    );

    // Algorithm to convert flat list ['#prod', 'name', '/prod'] to Structure
    int i = 0;
    while (i < rawFields.length) {
      String field = rawFields[i];

      if (field.startsWith('#')) {
        // FOUND A START TAG (e.g., "#productos")
        String sectionName = field.substring(1); // Remove '#'
        List<String> children = [];
        i++; // Move to next

        // Collect children until we hit the end tag
        while (i < rawFields.length &&
            !rawFields[i].startsWith('/$sectionName')) {
          // Verify it's not a nested loop (basic support only)
          if (!rawFields[i].startsWith('/')) {
            children.add(rawFields[i]);
          }
          i++;
        }

        // Create the Section
        _formStructure.add(
          FormSection(name: sectionName, isLoop: true, children: children),
        );
        _loopControllers[sectionName] = []; // Initialize empty list
        addLoopRow(sectionName, children); // Add 1st empty row by default
      } else if (!field.startsWith('/')) {
        // SIMPLE FIELD
        _formStructure.add(FormSection(name: field, isLoop: false));
        _simpleControllers[field] = TextEditingController();
      }
      i++;
    }

    notifyListeners();
  }

  // --- DYNAMIC ROW LOGIC ---

  void addLoopRow(String sectionName, List<String> childFields) {
    // Create a new map of controllers for this row
    Map<String, TextEditingController> newRow = {};
    for (var field in childFields) {
      newRow[field] = TextEditingController();
    }
    _loopControllers[sectionName]?.add(newRow);
    notifyListeners();
  }

  void removeLoopRow(String sectionName, int index) {
    if ((_loopControllers[sectionName]?.length ?? 0) > 1) {
      // Don't delete the last remaining row
      _loopControllers[sectionName]?.removeAt(index);
      notifyListeners();
    }
  }

  // --- GENERATION LOGIC ---

  Future<void> generateDocument() async {
    if (_selectedTemplate == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, Object> data = {};

      // 1. Add Simple Fields
      _simpleControllers.forEach((key, controller) {
        data[key] = controller.text;
      });

      // 2. Add Loop Fields (List of Maps)
      _loopControllers.forEach((sectionName, rows) {
        List<Map<String, String>> serializedRows = [];
        for (var row in rows) {
          Map<String, String> rowData = {};
          row.forEach((key, controller) {
            rowData[key] = controller.text;
          });
          serializedRows.add(rowData);
        }
        data[sectionName] = serializedRows;
      });

      print("Sending JSON: $data"); // Debugging

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

  @override
  void dispose() {
    for (var c in _simpleControllers.values) c.dispose();
    for (var rows in _loopControllers.values) {
      for (var row in rows) {
        for (var c in row.values) c.dispose();
      }
    }
    _pdfController?.dispose();
    super.dispose();
  }
}
