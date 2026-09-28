// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authScreenTitle => 'Welcome to the animal shelter';

  @override
  String get registerScreenTitle => 'Create shelter account';

  @override
  String get loginButton => 'Sign In';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign Up';

  @override
  String get authScreenPhoneLabel => 'Phone number';

  @override
  String get authScreenPasswordLabel => 'Password';

  @override
  String get usernameLabel => 'Username';

  @override
  String get displayNameLabel => 'Display name';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get authSuccessMessage => 'Successfully signed in!';

  @override
  String get registerSuccessMessage => 'Registration successful!';

  @override
  String get authFillAllFieldsError => 'Please fill in all fields';

  @override
  String get authInvalidCredentialsError => 'Invalid phone number or password';

  @override
  String get networkErrorMessage => 'Server connection error';

  @override
  String get serverErrorMessage => 'Server error';

  @override
  String get fieldRequiredError => 'This field is required';

  @override
  String get invalidPhoneFormatError =>
      'Invalid format (+77011234567, 8 to 15 digits)';

  @override
  String get invalidUsernameFormatError =>
      '3 to 30 characters (letters, numbers and _)';

  @override
  String get displayNameTooLongError => 'Name must not exceed 50 characters';

  @override
  String get passwordTooShortError => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match';
}
