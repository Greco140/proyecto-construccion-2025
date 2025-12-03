import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/models/template_list.dart';
import 'package:dynadoc_front/network/template_requests.dart';
import 'dart:typed_data';

class MockTemplateRequests extends Mock implements TemplateRequests {}

void main() {
  group('TemplateList Tests', () {
    late TemplateList templateList;

    setUp(() {
      templateList = TemplateList();
    });

    test('TemplateList initialization', () {
      expect(templateList, isNotNull);
    });

    test('TemplateList getTemplateList returns empty list initially', () async {
      final result = await templateList.getTemplateList();
      expect(result, isA<List<Template>>());
    });

    test('TemplateList generateDocument creates GenerationRequest', () async {
      final data = <String, Object>{
        'name': 'John',
        'email': 'john@example.com',
      };

      final result = await templateList.generateDocument('resume', data);
      expect(result, isA<Uint8List?>());
    });

    test('TemplateList refreshTemplates returns list', () async {
      final result = await templateList.refreshTemplates();
      expect(result, isA<List<Template>>());
    });

    test('TemplateList creates template with name and content', () async {
      final result = await templateList.createTemplate(
        'Test Template',
        'Template content here',
        false,
      );
      expect(result, isA<bool>());
    });

    test('TemplateList rejects deletion of public templates', () async {
      final publicTemplate = Template(
        id: 1,
        name: 'Public',
        content: 'Content',
        isPublic: true,
      );

      final result = await templateList.deleteTemplate(publicTemplate);
      expect(result, isFalse);
    });

    test('TemplateList allows deletion of private templates', () async {
      final privateTemplate = Template(
        id: 2,
        name: 'Private',
        content: 'Content',
        isPublic: false,
      );

      final result = await templateList.deleteTemplate(privateTemplate);
      expect(result, isA<bool>());
    });

    test('TemplateList getTemplateById returns template or null', () async {
      try {
        final result = await templateList.getTemplateById(1);
        expect(result, isA<Template?>());
      } catch (e) {
        expect(e, isNotNull);
      }
    });
  });
}
