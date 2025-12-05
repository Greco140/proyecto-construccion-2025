import 'package:flutter/material.dart';
import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/models/template_list.dart';

class MyTemplatesViewModel extends ChangeNotifier {
  final TemplateList _templateList = TemplateList();

  List<Template> _privateTemplates = [];
  Template? _selectedTemplate;
  bool _isLoading = false;
  String _errorMessage = '';

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  List<Template> get privateTemplates => _privateTemplates;
  Template? get selectedTemplate => _selectedTemplate;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> loadPrivateTemplates() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final allTemplates = await _templateList.getTemplateList();
      _privateTemplates = allTemplates.where((t) => !t.isPublic).toList();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error cargando plantillas: $e';
      _privateTemplates = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectTemplate(Template template) {
    _selectedTemplate = template;
    titleController.text = template.name;
    contentController.text = template.content;
    notifyListeners();
  }

  void clearSelection() {
    _selectedTemplate = null;
    titleController.clear();
    contentController.clear();
    notifyListeners();
  }

  Future<bool> updateSelectedTemplate() async {
    if (_selectedTemplate == null) {
      _errorMessage = 'No hay plantilla seleccionada';
      return false;
    }

    if (titleController.text.isEmpty) {
      _errorMessage = 'Titulo no puede estar vacío';
      return false;
    }

    if (contentController.text.isEmpty) {
      _errorMessage = 'Contenido no puede estar vacío';
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final success = await _templateList.updateTemplate(
        _selectedTemplate!,
        titleController.text,
        contentController.text,
        false,
      );

      if (success) {
        _errorMessage = '';
        await loadPrivateTemplates();
        clearSelection();
        return true;
      } else {
        _errorMessage = 'Fallo al actualizar la plantilla';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error al actualizar plantilla: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTemplate(Template template) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _templateList.deleteTemplate(template);
      if (success) {
        _errorMessage = '';
        await loadPrivateTemplates();
        if (_selectedTemplate?.id == template.id) {
          clearSelection();
        }
        return true;
      } else {
        _errorMessage = 'No puedes borrar plantillas públicas';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error al borrar plantilla: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }
}
