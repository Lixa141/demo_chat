import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get chatLog => 'Лог чата';

  @override
  String get sendMessage => 'Отправить сообщение...';

  @override
  String get youOffline => 'Вы находитесь в оффлайн режиме';

  @override
  String get errorNoInternet => 'Ошибка, проверьте подключение к интернету';

  @override
  String get again => 'Еще раз';

  @override
  String get loginHint => 'Пожалуйста введите от 3 до 20 символов без спец.знаков';

  @override
  String get userName => 'Имя пользователя';

  @override
  String get enter => 'Вход';

  @override
  String get createRoom => 'Создать комнату';

  @override
  String get createRoomHintOne => 'Пожалуйста введите более 3-х символов';

  @override
  String get createRoomHintTwo => 'Имя не должно содержать больше 20 символов';

  @override
  String get roomName => 'Имя комнаты';

  @override
  String get rooms => 'Комнаты';

  @override
  String get connectionStatusRetry => 'соединение потеряно, переподключение...';

  @override
  String get connectionStatusRestored => 'соединение восстановлено';
}
