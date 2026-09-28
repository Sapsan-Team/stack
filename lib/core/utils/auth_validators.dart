import 'package:todo/l10n/app_localizations.dart';

class AuthValidators {
  static final RegExp _phoneRegex = RegExp(r'^\+[1-9]\d{7,14}$');
  static final RegExp _usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,30}$');

  static String? validatePhone(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return l10n.fieldRequiredError;
    }
    if (!_phoneRegex.hasMatch(trimmed)) {
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
