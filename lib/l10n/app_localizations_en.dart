// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get authScreenTitle => 'Welcome to the cum zone!';

  @override
  String get loginButton => 'Login';

  @override
  String get signupButton => 'Sign up';

  @override
  String get authScreenPhoneLabel => 'Phone number';

  @override
  String get authScreenPasswordLabel => 'Password';

  @override
  String get authSuccessMessage => 'Successfully signed in!';
}
