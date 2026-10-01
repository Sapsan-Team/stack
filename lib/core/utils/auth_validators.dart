import 'package:todo/l10n/app_localizations.dart';

class AuthValidators {
  static final RegExp _phoneRegex = RegExp(r'^\+[1-9]\d{7,14}$');
  static final RegExp _localPhoneRegex = RegExp(r'^8\d{10}$');
  static final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,30}$');

  static String? normalizePhoneNumber(String? value) {
    final input = (value ?? '').trim().replaceAll(RegExp(r'[\s()-]'), '');
    if (_phoneRegex.hasMatch(input)) {
      return input;
    }
    if (_localPhoneRegex.hasMatch(input)) {
      return '+7${input.substring(1)}';
    }
    if (RegExp(r'^[1-9]\d{7,14}$').hasMatch(input)) {
      return '+$input';
    }
    return null;
  }

  static String? validatePhone(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return l10n.fieldRequiredError;
    }
    if (normalizePhoneNumber(trimmed) == null) {
      return l10n.invalidPhoneFormatError;
    }
    return null;
  }

  static String? validateUsername(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return l10n.fieldRequiredError;
    }
    if (!_usernameRegex.hasMatch(trimmed)) {
      return l10n.invalidUsernameFormatError;
    }
    return null;
  }

  static String? validateDisplayName(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return l10n.fieldRequiredError;
    }
    if (trimmed.length > 50) {
      return l10n.displayNameTooLongError;
    }
    return null;
  }

  static String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.fieldRequiredError;
    }
    if (value.length < 8) {
      return l10n.passwordTooShortError;
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.fieldRequiredError;
    }
    if (value != password) {
      return l10n.passwordsDoNotMatchError;
    }
    return null;
  }
}
