import 'package:flutter_test/flutter_test.dart';
import 'package:dynadoc_front/models/template.dart';
import 'package:dynadoc_front/models/template_field.dart';
import 'package:dynadoc_front/models/user.dart';

void main() {
  group('Template Model Tests', () {
    test('Template creation with required fields', () {
      final template = Template(
        name: 'Test Template',
        content: 'This is a test {{placeholder}}',
      );

      expect(template.name, equals('Test Template'));
      expect(template.content, equals('This is a test {{placeholder}}'));
      expect(template.id, isNull);
      expect(template.isPublic, isFalse);
      expect(template.owner, isNull);
      expect(template.fields, isEmpty);
    });

    test('Template creation with all fields', () {
      final owner = User(
        id: 1,
        name: 'Template Owner',
        email: 'owner@example.com',
      );

      final field1 = TemplateField(name: 'name', content: '');
      final field2 = TemplateField(name: 'email', content: '');

      final template = Template(
        id: 5,
        name: 'Complete Template',
        content: 'Content here',
        isPublic: true,
        owner: owner,
        fields: [field1, field2],
      );

      expect(template.id, equals(5));
      expect(template.name, equals('Complete Template'));
      expect(template.content, equals('Content here'));
      expect(template.isPublic, isTrue);
      expect(template.owner, equals(owner));
      expect(template.fields.length, equals(2));
    });

    test('Template.fromJson with basic data', () {
      final json = {
        'id': 10,
        'name': 'JSON Template',
        'content': 'Template content',
        'isPublic': false,
      };

      final template = Template.fromJson(json);

      expect(template.id, equals(10));
      expect(template.name, equals('JSON Template'));
      expect(template.content, equals('Template content'));
      expect(template.isPublic, isFalse);
    });

    test('Template.fromJson with public field instead of isPublic', () {
      final json = {
        'id': 20,
        'name': 'Public Template',
        'content': 'Public content',
        'public': true,
      };

      final template = Template.fromJson(json);

      expect(template.isPublic, isTrue);
    });

    test('Template.fromJson with owner', () {
      final json = {
        'id': 30,
        'name': 'Owned Template',
        'content': 'Content',
        'isPublic': false,
        'owner': {
          'id': 1,
          'name': 'John Doe',
          'email': 'john@example.com',
          'role': 'admin',
        },
      };

      final template = Template.fromJson(json);

      expect(template.owner, isNotNull);
      expect(template.owner!.name, equals('John Doe'));
      expect(template.owner!.email, equals('john@example.com'));
    });

    test('Template.fromJson with placeholders', () {
      final json = {
        'id': 40,
        'name': 'Template with Fields',
        'content': 'Hello {{name}}, your email is {{email}}',
        'isPublic': false,
        'placeholders': ['name', 'email', 'phone'],
      };

      final template = Template.fromJson(json);

      expect(template.fields.length, equals(3));
      expect(template.fields[0].getName(), equals('name'));
      expect(template.fields[1].getName(), equals('email'));
      expect(template.fields[2].getName(), equals('phone'));
    });

    test('Template.fromJson with null owner', () {
      final json = {
        'id': 50,
        'name': 'Public Template',
        'content': 'Content',
        'isPublic': true,
        'owner': null,
      };

      final template = Template.fromJson(json);

      expect(template.owner, isNull);
    });

    test('Template.fromJson without isPublic defaults to false', () {
      final json = {'id': 60, 'name': 'Default Public', 'content': 'Content'};

      final template = Template.fromJson(json);

      expect(template.isPublic, isFalse);
    });

    test('Template.fromJson with null placeholders', () {
      final json = {
        'id': 70,
        'name': 'No Fields Template',
        'content': 'Simple content',
        'isPublic': false,
        'placeholders': null,
      };

      final template = Template.fromJson(json);

      expect(template.fields.isEmpty, isTrue);
    });

    test('Template fields are initialized as empty content', () {
      final json = {
        'id': 80,
        'name': 'Fields Test',
        'content': 'Content {{var1}} {{var2}}',
        'isPublic': false,
        'placeholders': ['var1', 'var2'],
      };

      final template = Template.fromJson(json);

      for (final field in template.fields) {
        expect(field.getContent(), equals(''));
      }
    });

    test('Template with complex placeholder list', () {
      final json = {
        'id': 90,
        'name': 'Complex Template',
        'content': 'Content',
        'isPublic': false,
        'placeholders': ['field1', 'field2', 'field3', 'field4', 'field5'],
      };

      final template = Template.fromJson(json);

      expect(template.fields.length, equals(5));
      for (int i = 0; i < template.fields.length; i++) {
        expect(template.fields[i].getName(), equals('field${i + 1}'));
      }
    });
  });
}
