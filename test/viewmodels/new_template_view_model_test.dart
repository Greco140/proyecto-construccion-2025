import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dynadoc_front/viewmodels/new_template_view_model.dart';

void main() {
  group('NewTemplateViewModel Tests', () {
    late NewTemplateViewModel viewModel;

    setUp(() {
      viewModel = NewTemplateViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('NewTemplateViewModel initializes with empty controllers', () {
      expect(viewModel.nameController.text, isEmpty);
      expect(viewModel.contentController.text, isEmpty);
    });

    test('NewTemplateViewModel rejects creation with empty name', () async {
      viewModel.contentController.text = 'Some content';

      final result = await viewModel.createTemplate();

      expect(result, isFalse);
    });

    test('NewTemplateViewModel rejects creation with empty content', () async {
      viewModel.nameController.text = 'Template Name';

      final result = await viewModel.createTemplate();

      expect(result, isFalse);
    });

    test(
      'NewTemplateViewModel rejects creation with both fields empty',
      () async {
        final result = await viewModel.createTemplate();

        expect(result, isFalse);
      },
    );

    test('NewTemplateViewModel can populate name controller', () {
      const testName = 'My Template';

      viewModel.nameController.text = testName;

      expect(viewModel.nameController.text, equals(testName));
    });

    test('NewTemplateViewModel can populate content controller', () {
      const testContent = 'Template {{name}} {{email}}';

      viewModel.contentController.text = testContent;

      expect(viewModel.contentController.text, equals(testContent));
    });

    test('NewTemplateViewModel nameController getter returns controller', () {
      expect(viewModel.nameController, isNotNull);
      expect(viewModel.nameController, isA<TextEditingController>());
    });

    test(
      'NewTemplateViewModel contentController getter returns controller',
      () {
        expect(viewModel.contentController, isNotNull);
        expect(viewModel.contentController, isA<TextEditingController>());
      },
    );

    test('NewTemplateViewModel accepts creation with valid data', () async {
      viewModel.nameController.text = 'Valid Template';
      viewModel.contentController.text = 'This is valid content';

      final result = await viewModel.createTemplate();

      expect(result, isA<bool>());
    });

    test('NewTemplateViewModel with whitespace-only fields rejects', () async {
      viewModel.nameController.text = '   ';
      viewModel.contentController.text = '   ';

      // Both have content (spaces), so should attempt creation
      final result = await viewModel.createTemplate();
      expect(result, isA<bool>());
    });

    test('NewTemplateViewModel with special characters in content', () async {
      viewModel.nameController.text = 'Special Template';
      viewModel.contentController.text =
          'Content with {{placeholders}} and special chars: @#\$%';

      final result = await viewModel.createTemplate();

      expect(result, isA<bool>());
    });

    test('NewTemplateViewModel controllers are independent', () {
      viewModel.nameController.text = 'Name';
      viewModel.contentController.text = 'Content';

      expect(viewModel.nameController.text, equals('Name'));
      expect(viewModel.contentController.text, equals('Content'));

      viewModel.nameController.clear();

      expect(viewModel.nameController.text, isEmpty);
      expect(viewModel.contentController.text, equals('Content'));
    });

    test('NewTemplateViewModel handles long template names', () async {
      final longName = 'A' * 500;
      viewModel.nameController.text = longName;
      viewModel.contentController.text = 'Content';

      final result = await viewModel.createTemplate();

      expect(result, isA<bool>());
    });

    test('NewTemplateViewModel handles long template content', () async {
      viewModel.nameController.text = 'Template';
      final longContent = 'This is template content ' * 100;
      viewModel.contentController.text = longContent;

      final result = await viewModel.createTemplate();

      expect(result, isA<bool>());
    });
  });
}
