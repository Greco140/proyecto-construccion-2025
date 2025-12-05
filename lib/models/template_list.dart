import 'dart:typed_data';
import 'package:dynadoc_front/models/generation_request.dart';
import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/network/template_requests.dart';

class TemplateList {
  final TemplateRequests _requests = TemplateRequests();

  List<Template> _templateList = [];

  Future<List<Template>> getTemplateList() async {
    if (_templateList.isEmpty) await refreshTemplates();
    return _templateList;
  }

  Future<List<Template>> refreshTemplates() async {
    try {
      _templateList = await _requests.getTemplateList();
      return _templateList;
    } catch (e) {
      print('Repo Error: $e');
      return [];
    }
  }

  Future<Template?> getTemplateById(int id) async {
    return await _requests.getTemplateById(id);
  }

  Future<bool> createTemplate(
    String name,
    String content,
    bool isPublic,
  ) async {
    try {
      await _requests.createTemplate(name, content, isPublic);
      await refreshTemplates();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTemplate(
    Template template,
    String name,
    String content,
    bool isPublic,
  ) async {
    try {
      await _requests.updateTemplate(template.id!, name, content, isPublic);
      await refreshTemplates();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTemplate(Template template) async {
    if (template.isPublic) return false;
    try {
      await _requests.deleteTemplate(template.id!);
      await refreshTemplates();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Uint8List?> generateDocument(
    String templateType,
    Map<String, Object> data,
  ) async {
    final request = GenerationRequest(templateType: templateType, data: data);
    return await _requests.generateDocument(request);
  }
}
