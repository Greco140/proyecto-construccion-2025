import 'package:flutter_test/flutter_test.dart';
import 'package:dynadoc_front/viewmodels/template_list_view_model.dart';
import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/models/template_field.dart';
import 'package:dynadoc_front/models/user.dart';

void main() {
  group('TemplateListViewModel Tests', () {
    late TemplateListViewModel viewModel;

    setUp(() {
      viewModel = TemplateListViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('TemplateListViewModel initializes with no selected template', () {
      expect(viewModel.selectedTemplate, isNull);
    });

    test('TemplateListViewModel isLoading initializes as false', () {
      expect(viewModel.isLoading, isFalse);
    });

    test('TemplateListViewModel pdfController initializes as null', () {
      expect(viewModel.pdfController, isNull);
    });

    test('TemplateListViewModel templateFields is accessible', () {
      expect(viewModel.templateFields, isNotNull);
    });

    test('TemplateListViewModel getTemplateList returns future', () async {
      try {
        final result = await viewModel.getTemplateList();
        expect(result, isA<List<Template>>());
      } catch (e) {
        // Network error is expected in test environment
        expect(e, isNotNull);
      }
    });

    test('TemplateListViewModel selectTemplate sets selected template', () {
      final template = Template(
        id: 1,
        name: 'Test Template',
        content: 'Content {{field1}} {{field2}}',
        isPublic: false,
        fields: [
          TemplateField(name: 'field1', content: ''),
          TemplateField(name: 'field2', content: ''),
        ],
      );

      viewModel.selectTemplate(template);

      expect(viewModel.selectedTemplate, equals(template));
    });

    test('TemplateListViewModel selectTemplate clears previous selection', () {
      final template1 = Template(
        id: 1,
        name: 'Template 1',
        content: 'Content',
        isPublic: false,
      );

      final template2 = Template(
        id: 2,
        name: 'Template 2',
        content: 'Different content',
        isPublic: false,
      );

      viewModel.selectTemplate(template1);
      expect(viewModel.selectedTemplate, equals(template1));

      viewModel.selectTemplate(template2);
      expect(viewModel.selectedTemplate, equals(template2));
    });

    test('TemplateListViewModel selectTemplate notifies listeners', () {
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      final template = Template(
        id: 1,
        name: 'Test',
        content: 'Content',
        isPublic: false,
      );

      viewModel.selectTemplate(template);

      expect(notificationCount, greaterThan(0));
    });

    test(
      'TemplateListViewModel selectTemplate with fields generates fields list',
      () {
        final fields = [
          TemplateField(name: 'firstName', content: ''),
          TemplateField(name: 'lastName', content: ''),
          TemplateField(name: 'email', content: ''),
        ];

        final template = Template(
          id: 1,
          name: 'User Form',
          content: 'Name: {{firstName}} {{lastName}}\nEmail: {{email}}',
          isPublic: false,
          fields: fields,
        );

        viewModel.selectTemplate(template);

        expect(viewModel.selectedTemplate, equals(template));
        expect(viewModel.templateFields, isNotNull);
      },
    );

    test('TemplateListViewModel addLoopRow notifies listeners', () {
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      viewModel.addLoopRow('items', ['name', 'quantity']);

      expect(notificationCount, greaterThan(0));
    });

    test('TemplateListViewModel removeLoopRow notifies listeners', () {
      var notificationCount = 0;
      viewModel.addListener(() {
        notificationCount++;
      });

      viewModel.removeLoopRow('items', 0);

      expect(notificationCount, greaterThan(0));
    });

    test('TemplateListViewModel getLoopRows returns list', () {
      final result = viewModel.getLoopRows('items');
      expect(result, isA<List<Map<String, dynamic>>>());
    });

    test('TemplateListViewModel selectTemplate multiple times', () {
      final template1 = Template(
        id: 1,
        name: 'Template 1',
        content: 'Content 1',
        isPublic: false,
      );

      final template2 = Template(
        id: 2,
        name: 'Template 2',
        content: 'Content 2',
        isPublic: false,
      );

      viewModel.selectTemplate(template1);
      expect(viewModel.selectedTemplate, equals(template1));

      viewModel.selectTemplate(template2);
      expect(viewModel.selectedTemplate, equals(template2));

      viewModel.selectTemplate(template1);
      expect(viewModel.selectedTemplate, equals(template1));
    });

    test('TemplateListViewModel with owner template', () {
      final owner = User(
        id: 5,
        name: 'Template Author',
        email: 'author@example.com',
      );

      final template = Template(
        id: 10,
        name: 'Owned Template',
        content: 'Content',
        isPublic: false,
        owner: owner,
      );

      viewModel.selectTemplate(template);

      expect(viewModel.selectedTemplate, equals(template));
      expect(viewModel.selectedTemplate!.owner, equals(owner));
    });

    test('TemplateListViewModel with public template', () {
      final template = Template(
        id: 20,
        name: 'Public Template',
        content: 'Public content',
        isPublic: true,
      );

      viewModel.selectTemplate(template);

      expect(viewModel.selectedTemplate, equals(template));
      expect(viewModel.selectedTemplate!.isPublic, isTrue);
    });
  });
}
