// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get authScreenTitle => 'Здарова заебал!';

  @override
  String get loginButton => 'Авторизоваться';

  @override
  String get signupButton => 'Зарегистрироваться';

  @override
  String get authScreenPhoneLabel => 'Номер телефона';

  @override
  String get authScreenPasswordLabel => 'Пароль';
}
