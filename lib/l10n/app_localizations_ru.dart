// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get authScreenTitle => 'Добро пожаловать в приют для животных';

  @override
  String get loginButton => 'Авторизоваться';

  @override
  String get signupButton => 'Зарегистрироваться';

  @override
  String get authScreenPhoneLabel => 'Номер телефона';

  @override
  String get authScreenPasswordLabel => 'Пароль';

  @override
  String get authSuccessMessage => 'Авторизация прошла успешно!';

  @override
  String get authFillAllFieldsError => 'Заполните все поля';

  @override
  String get authInvalidCredentialsError =>
      'Неверный номер телефона или пароль';

  @override
  String get networkErrorMessage => 'Ошибка подключения к серверу';

  @override
  String get serverErrorMessage => 'Ошибка сервера';
}
