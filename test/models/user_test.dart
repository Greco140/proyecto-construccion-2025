import 'package:flutter_test/flutter_test.dart';
import 'package:dynadoc_front/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User creation with all fields', () {
      final user = User(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        role: 'admin',
      );

      expect(user.id, equals(1));
      expect(user.name, equals('John Doe'));
      expect(user.email, equals('john@example.com'));
      expect(user.role, equals('admin'));
    });

    test('User creation with required email only', () {
      final user = User(email: 'test@example.com');

      expect(user.email, equals('test@example.com'));
      expect(user.id, isNull);
      expect(user.name, isNull);
      expect(user.role, isNull);
    });

    test('User.fromJson creates user from JSON', () {
      final json = {
        'id': 5,
        'name': 'Jane Doe',
        'email': 'jane@example.com',
        'role': 'user',
      };

      final user = User.fromJson(json);

      expect(user.id, equals(5));
      expect(user.name, equals('Jane Doe'));
      expect(user.email, equals('jane@example.com'));
      expect(user.role, equals('user'));
    });

    test('User.fromJson handles missing optional fields', () {
      final json = {'email': 'minimal@example.com'};

      final user = User.fromJson(json);

      expect(user.email, equals('minimal@example.com'));
      expect(user.id, isNull);
      expect(user.name, isNull);
      expect(user.role, isNull);
    });

    test('User.toJson converts user to JSON', () {
      final user = User(
        id: 10,
        name: 'Test User',
        email: 'test@example.com',
        role: 'editor',
      );

      final json = user.toJson();

      expect(json['id'], equals(10));
      expect(json['name'], equals('Test User'));
      expect(json['email'], equals('test@example.com'));
      expect(json['role'], equals('editor'));
    });

    test('User.toJson includes null values', () {
      final user = User(email: 'only-email@example.com');

      final json = user.toJson();

      expect(json.containsKey('id'), isTrue);
      expect(json.containsKey('name'), isTrue);
      expect(json.containsKey('email'), isTrue);
      expect(json.containsKey('role'), isTrue);
      expect(json['id'], isNull);
      expect(json['name'], isNull);
    });

    test('User JSON roundtrip preserves data', () {
      final originalUser = User(
        id: 42,
        name: 'Roundtrip User',
        email: 'roundtrip@example.com',
        role: 'viewer',
      );

      final json = originalUser.toJson();
      final newUser = User.fromJson(json);

      expect(newUser.id, equals(originalUser.id));
      expect(newUser.name, equals(originalUser.name));
      expect(newUser.email, equals(originalUser.email));
      expect(newUser.role, equals(originalUser.role));
    });
  });
}
