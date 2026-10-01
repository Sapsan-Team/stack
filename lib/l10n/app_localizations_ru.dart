// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get authScreenTitle => 'С возвращением';

  @override
  String get authScreenSubtitle => 'Войдите, чтобы продолжить';

  @override
  String get registerScreenTitle => 'Создать аккаунт';

  @override
  String get registerScreenSubtitle => 'Заполните данные, чтобы начать';

  @override
  String get loginButton => 'Войти';

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
  String get invalidPhoneFormatError => 'Введите корректный номер';

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
  String get emptyStateSubtitle => 'Здесь пока ничего нет. Загляните позже.';

  @override
  String get navHome => 'Главная';

  @override
  String get navCalls => 'Звонки';

  @override
  String get navMusic => 'Музыка';

  @override
  String get navProfile => 'Профиль';

  @override
  String get home => 'Главная';

  @override
  String get switchToLightTheme => 'Включить светлую тему';

  @override
  String get switchToDarkTheme => 'Включить тёмную тему';

  @override
  String get switchLanguage => 'Сменить язык';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get sessionVerificationError =>
      'Не удалось проверить сессию. Проверьте подключение и повторите попытку.';

  @override
  String get retryButton => 'Повторить';
}
