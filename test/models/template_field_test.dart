import 'package:flutter_test/flutter_test.dart';
import 'package:dynadoc_front/models/template_field.dart';

void main() {
  group('TemplateField Model Tests', () {
    test('TemplateField creation with name and content', () {
      final field = TemplateField(name: 'firstName', content: 'John');

      expect(field.getName(), equals('firstName'));
      expect(field.getContent(), equals('John'));
    });

    test('TemplateField with empty content', () {
      final field = TemplateField(name: 'address', content: '');

      expect(field.getName(), equals('address'));
      expect(field.getContent(), equals(''));
    });

    test('TemplateField.setContent updates content', () {
      final field = TemplateField(name: 'phone', content: '555-0000');

      field.setContent('555-1234');

      expect(field.getContent(), equals('555-1234'));
    });

    test('TemplateField.setContent with empty string', () {
      final field = TemplateField(name: 'email', content: 'test@example.com');

      field.setContent('');

      expect(field.getContent(), equals(''));
    });

    test('TemplateField.toJson converts field to JSON', () {
      final field = TemplateField(name: 'department', content: 'Engineering');

      final json = field.toJson();

      expect(json['name'], equals('department'));
      expect(json['content'], equals('Engineering'));
    });

    test('TemplateField.toJson with special characters', () {
      final field = TemplateField(
        name: 'description',
        content: 'Special chars: @#\$%&*(){}[]<>',
      );

      final json = field.toJson();

      expect(json['name'], equals('description'));
      expect(json['content'], equals('Special chars: @#\$%&*(){}[]<>'));
    });

    test('Multiple TemplateField instances are independent', () {
      final field1 = TemplateField(name: 'field1', content: 'value1');
      final field2 = TemplateField(name: 'field2', content: 'value2');

      field1.setContent('updated1');

      expect(field1.getContent(), equals('updated1'));
      expect(field2.getContent(), equals('value2'));
      expect(field1.getName(), equals('field1'));
      expect(field2.getName(), equals('field2'));
    });

    test('TemplateField.toJson includes all required fields', () {
      final field = TemplateField(name: 'testField', content: 'testContent');
      final json = field.toJson();

      expect(json.keys.length, equals(2));
      expect(json.containsKey('name'), isTrue);
      expect(json.containsKey('content'), isTrue);
    });
  });
}
