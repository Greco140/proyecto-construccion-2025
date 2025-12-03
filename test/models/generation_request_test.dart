import 'package:flutter_test/flutter_test.dart';
import 'package:dynadoc_front/models/generation_request.dart';

void main() {
  group('GenerationRequest Model Tests', () {
    test('GenerationRequest creation with data', () {
      final data = {'firstName': 'John', 'lastName': 'Doe', 'age': 30};

      final request = GenerationRequest(templateType: 'resume', data: data);

      expect(request.templateType, equals('resume'));
      expect(request.data, equals(data));
    });

    test('GenerationRequest with empty data', () {
      final request = GenerationRequest(templateType: 'blank', data: {});

      expect(request.templateType, equals('blank'));
      expect(request.data.isEmpty, isTrue);
    });

    test('GenerationRequest with different template types', () {
      final types = ['certificate', 'letter', 'invoice', 'report'];

      for (final type in types) {
        final request = GenerationRequest(templateType: type, data: {});
        expect(request.templateType, equals(type));
      }
    });

    test('GenerationRequest.toJson converts to JSON', () {
      final data = {'name': 'Test', 'value': 100};

      final request = GenerationRequest(templateType: 'document', data: data);

      final json = request.toJson();

      expect(json['templateType'], equals('document'));
      expect(json['data'], equals(data));
    });

    test('GenerationRequest.toJson with complex nested data', () {
      final data = {
        'user': {'name': 'John', 'email': 'john@example.com'},
        'items': [1, 2, 3],
        'isActive': true,
      };

      final request = GenerationRequest(templateType: 'complex', data: data);

      final json = request.toJson();

      expect(json['templateType'], equals('complex'));
      expect(json['data']['user']['name'], equals('John'));
      expect(json['data']['items'], equals([1, 2, 3]));
      expect(json['data']['isActive'], isTrue);
    });

    test('GenerationRequest data is mutable', () {
      final data = <String, Object>{'key': 'value'};
      final request = GenerationRequest(templateType: 'test', data: data);

      data['newKey'] = 'newValue';

      expect(request.data.containsKey('newKey'), isTrue);
      expect(request.data['newKey'], equals('newValue'));
    });

    test('GenerationRequest with numeric and string values', () {
      final data = <String, Object>{
        'stringValue': 'text',
        'intValue': 42,
        'doubleValue': 3.14,
        'boolValue': true,
      };

      final request = GenerationRequest(templateType: 'mixed', data: data);

      expect(request.data['stringValue'], equals('text'));
      expect(request.data['intValue'], equals(42));
      expect(request.data['doubleValue'], equals(3.14));
      expect(request.data['boolValue'], isTrue);
    });
  });
}
