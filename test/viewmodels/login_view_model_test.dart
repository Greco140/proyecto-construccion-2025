import 'package:flutter_test/flutter_test.dart';
import 'package:dynadoc_front/viewmodels/login_view_model.dart';

void main() {
  group('LoginViewModel Tests', () {
    late LoginViewModel viewModel;

    setUp(() {
      viewModel = LoginViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('LoginViewModel initializes with correct default values', () {
      expect(viewModel.isInRegistrationState(), isFalse);
    });

    test('LoginViewModel validateEmail with valid email', () {
      const validEmails = [
        'user@example.com',
        'test.user@example.co.uk',
        'name+tag@example.com',
        'user123@test-domain.com',
      ];

      for (final email in validEmails) {
        expect(
          viewModel.validateEmail(email),
          isTrue,
          reason: 'Email $email should be valid',
        );
      }
    });

    test('LoginViewModel validateEmail with invalid email', () {
      const invalidEmails = [
        'notanemail',
        'missing@domain',
        '@nodomain.com',
        'spaces in@email.com',
        'double@@domain.com',
      ];

      for (final email in invalidEmails) {
        expect(
          viewModel.validateEmail(email),
          isFalse,
          reason: 'Email $email should be invalid',
        );
      }
    });

    test('LoginViewModel validateEmail with null returns false', () {
      expect(viewModel.validateEmail(null), isFalse);
    });

    test('LoginViewModel validateEmail with empty string returns false', () {
      expect(viewModel.validateEmail(''), isFalse);
    });

    test('LoginViewModel validateText with valid text', () {
      expect(viewModel.validateText('some text'), isTrue);
      expect(viewModel.validateText('a'), isTrue);
      expect(viewModel.validateText('123'), isTrue);
    });

    test('LoginViewModel validateText with empty or null text', () {
      expect(viewModel.validateText(null), isFalse);
      expect(viewModel.validateText(''), isFalse);
      expect(viewModel.validateText('   '), isTrue); // Spaces are not trimmed
    });

    test('LoginViewModel confirmPassword matches passwords', () {
      viewModel.getPasswordController().text = 'myPassword123';

      expect(viewModel.confirmPassword('myPassword123'), isTrue);
    });

    test('LoginViewModel confirmPassword with different passwords', () {
      viewModel.getPasswordController().text = 'password1';

      expect(viewModel.confirmPassword('password2'), isFalse);
    });

    test('LoginViewModel confirmPassword with null', () {
      viewModel.getPasswordController().text = 'password';

      expect(viewModel.confirmPassword(null), isFalse);
    });

    test('LoginViewModel confirmPassword case sensitive', () {
      viewModel.getPasswordController().text = 'Password123';

      expect(viewModel.confirmPassword('password123'), isFalse);
      expect(viewModel.confirmPassword('Password123'), isTrue);
    });

    test('LoginViewModel initial registration state', () {
      // Can't test setRegistrationState in unit tests as it requires Flutter binding
      // Just verify isInRegistrationState method exists and can be called
      final state = viewModel.isInRegistrationState();
      expect(state, isFalse);
    });

    test('LoginViewModel formKey is accessible', () {
      expect(viewModel.getFormKey(), isNotNull);
    });

    test('LoginViewModel controllers are accessible', () {
      expect(viewModel.getEmailController(), isNotNull);
      expect(viewModel.getPasswordController(), isNotNull);
      expect(viewModel.getNameController(), isNotNull);
      expect(viewModel.getPassConfirmController(), isNotNull);
    });

    test('LoginViewModel controllers can be populated', () {
      viewModel.getEmailController().text = 'test@example.com';
      viewModel.getPasswordController().text = 'password123';
      viewModel.getNameController().text = 'Test User';

      expect(viewModel.getEmailController().text, equals('test@example.com'));
      expect(viewModel.getPasswordController().text, equals('password123'));
      expect(viewModel.getNameController().text, equals('Test User'));
    });

    test('LoginViewModel validateEmail with special characters', () {
      expect(viewModel.validateEmail('user+tag@example.com'), isTrue);
      expect(viewModel.validateEmail('first.last@example.com'), isTrue);
      expect(viewModel.validateEmail('user_name@example.com'), isTrue);
    });

    test('LoginViewModel password confirmation with empty strings', () {
      viewModel.getPasswordController().text = '';

      expect(viewModel.confirmPassword(''), isTrue);
      expect(viewModel.confirmPassword('somepassword'), isFalse);
    });

    test('LoginViewModel multiple state checks', () {
      expect(viewModel.isInRegistrationState(), isFalse);

      // Can't test setRegistrationState in unit tests as it requires Flutter binding
      // But we can verify the getter works multiple times
      for (int i = 0; i < 5; i++) {
        expect(viewModel.isInRegistrationState(), isFalse);
      }
    });
  });
}
