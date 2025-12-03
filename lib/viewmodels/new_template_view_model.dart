import 'package:dynadoc_front/models/template_list.dart';
import 'package:flutter/material.dart';

class NewTemplateViewModel extends ChangeNotifier {
  final TemplateList templates = TemplateList();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isPublic = false;

  TextEditingController get nameController => _nameController;
  TextEditingController get contentController => _contentController;

  Future<bool> createTemplate() async {
    if (nameController.text.isEmpty || contentController.text.isEmpty)
      return false;
    bool result = await templates.createTemplate(
      nameController.text,
      contentController.text,
      _isPublic,
    );
    return result;
  }

  void setCreateAsPublic(bool value) {
    _isPublic = value;
    notifyListeners();
  }

  bool get isPublic => _isPublic;

  void clear() {
    _nameController.clear();
    _contentController.clear();
  }
}
