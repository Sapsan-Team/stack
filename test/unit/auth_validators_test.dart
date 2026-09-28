import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/core/utils/auth_validators.dart';
import 'package:todo/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10n;

  setUpAll(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('ru'));
  });

  group('AuthValidators', () {
    test('validatePhone validates E.164 phone numbers', () {
      expect(AuthValidators.validatePhone('', l10n), l10n.fieldRequiredError);
      expect(AuthValidators.validatePhone('12345', l10n), l10n.invalidPhoneFormatError);
      expect(AuthValidators.validatePhone('89991234567', l10n), l10n.invalidPhoneFormatError);
      expect(AuthValidators.validatePhone('+77011234567', l10n), isNull);
      expect(AuthValidators.validatePhone('+12345678901', l10n), isNull);
    });

    test('validateUsername validates 3-30 alphanumeric characters and underscore', () {
      expect(AuthValidators.validateUsername('', l10n), l10n.fieldRequiredError);
      expect(AuthValidators.validateUsername('ab', l10n), l10n.invalidUsernameFormatError);
      expect(AuthValidators.validateUsername('user name', l10n), l10n.invalidUsernameFormatError);
      expect(AuthValidators.validateUsername('user-name', l10n), l10n.invalidUsernameFormatError);
      expect(AuthValidators.validateUsername('user_123', l10n), isNull);
      expect(AuthValidators.validateUsername('john_doe', l10n), isNull);
    });

    test('validateDisplayName checks for empty and max length', () {
      expect(AuthValidators.validateDisplayName('', l10n), l10n.fieldRequiredError);
      expect(AuthValidators.validateDisplayName('A' * 51, l10n), l10n.displayNameTooLongError);
      expect(AuthValidators.validateDisplayName('John Doe', l10n), isNull);
    });

    test('validatePassword requires at least 8 characters', () {
      expect(AuthValidators.validatePassword('', l10n), l10n.fieldRequiredError);
      expect(AuthValidators.validatePassword('1234567', l10n), l10n.passwordTooShortError);
      expect(AuthValidators.validatePassword('password', l10n), isNull);
      expect(AuthValidators.validatePassword('12345678', l10n), isNull);
    });

    test('validateConfirmPassword checks matching password', () {
      expect(AuthValidators.validateConfirmPassword('', 'pass1234', l10n), l10n.fieldRequiredError);
      expect(AuthValidators.validateConfirmPassword('pass9999', 'pass1234', l10n), l10n.passwordsDoNotMatchError);
      expect(AuthValidators.validateConfirmPassword('pass1234', 'pass1234', l10n), isNull);
    });
  });
}
