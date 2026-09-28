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
  String get registerScreenTitle => 'Регистрация в приюте';

  @override
  String get loginButton => 'Авторизоваться';

  @override
  String get signupButton => 'Зарегистрироваться';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? Войти';

  @override
  String get dontHaveAccount => 'Нет аккаунта? Зарегистрироваться';

  @override
  String get authScreenPhoneLabel => 'Номер телефона';

  @override
  String get authScreenPasswordLabel => 'Пароль';

  @override
  String get usernameLabel => 'Имя пользователя (username)';

  @override
  String get displayNameLabel => 'Отображаемое имя';

  @override
  String get confirmPasswordLabel => 'Подтвердите пароль';

  @override
  String get authSuccessMessage => 'Авторизация прошла успешно!';

  @override
  String get registerSuccessMessage => 'Регистрация прошла успешно!';

  @override
  String get authFillAllFieldsError => 'Заполните все поля';

  @override
  String get authInvalidCredentialsError =>
      'Неверный номер телефона или пароль';

  @override
  String get networkErrorMessage => 'Ошибка подключения к серверу';

  @override
  String get serverErrorMessage => 'Ошибка сервера';

  @override
  String get fieldRequiredError => 'Обязательное поле';

  @override
  String get invalidPhoneFormatError =>
      'Неверный формат (+77011234567, от 8 до 15 цифр)';

  @override
  String get invalidUsernameFormatError =>
      'От 3 до 30 символов (латиница, цифры и _)';

  @override
  String get displayNameTooLongError => 'Имя не должно превышать 50 символов';

  @override
  String get passwordTooShortError => 'Пароль должен быть не менее 8 символов';

  @override
  String get passwordsDoNotMatchError => 'Пароли не совпадают';

  @override
  String get homeScreenTitle => 'Главная';

  @override
  String get logoutButton => 'Выйти';

  @override
  String get emptyStateTitle => 'Здесь пока ничего нет';

  @override
  String get emptyStateSubtitle => 'Список задач и питомцев пуст';

  @override
  String get navHome => 'Главная';

  @override
  String get navPets => 'Питомцы';

  @override
  String get navTasks => 'Задачи';

  @override
  String get navProfile => 'Профиль';

  @override
  String get home => 'Главная';

  @override
  String get materials => 'Материалы';

  @override
  String get my_vocabulary => 'Мой словарь';

  @override
  String get profile => 'Профиль';
}
