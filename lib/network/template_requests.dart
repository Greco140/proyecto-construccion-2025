import 'dart:typed_data';
import 'package:dynadoc_front/models/generation_request.dart';
import 'package:dynadoc_front/models/template.dart';
import 'http_request.dart';

class TemplateRequests extends HttpRequest {
  Future<List<Template>> getTemplateList() async {
    final List<dynamic> jsonList = await sendGetRequest('templates');
    return jsonList.map((json) => Template.fromJson(json)).toList();
  }

  Future<Template> getTemplateById(int id) async {
    final json = await sendGetRequest('templates/$id');
    return Template.fromJson(json);
  }

  Future<Template> createTemplate(
    String name,
    String content,
    bool isPublic,
  ) async {
    final body = {'name': name, 'content': content, 'isPublic': isPublic};
    final json = await sendPostRequest('templates', body);
    return Template.fromJson(json);
  }

  Future<Uint8List?> generateDocument(GenerationRequest request) async {
    try {
      final bytes = await sendPostRequestBytes('generatePDF', request.toJson());
      return Uint8List.fromList(bytes);
    } catch (e) {
      print('Generation Error: $e');
      return null;
    }
  }

  Future<bool> deleteTemplate(int id) async {
    try {
      await sendDeleteRequest('templates/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTemplate(
    int id,
    String name,
    String content,
    bool isPublic,
  ) async {
    final body = {'name': name, 'content': content, 'isPublic': isPublic};
    try {
      await sendPutRequest('templates/$id', body);
      return true;
    } catch (e) {
      return false;
    }
  }
}
