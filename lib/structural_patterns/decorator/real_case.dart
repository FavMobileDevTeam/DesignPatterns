/// Интерфейс сервиса данных
abstract class DataService {
  String fetchData(String key);
}

/// Конкретный сервис, получающий данные (например, через API)
class ApiDataService implements DataService {
  @override
  String fetchData(String key) {
    print('Запрос данных для $key через API');
    // Здесь могла бы быть логика HTTP-запроса
    return 'Data for $key';
  }
}

/// Базовый декоратор, реализующий тот же интерфейс и хранящий вложенный сервис
class DataServiceDecorator implements DataService {
  final DataService inner;
  DataServiceDecorator(this.inner);

  @override
  String fetchData(String key) {
    // По умолчанию просто делегируем вызов внутреннему сервису
    return inner.fetchData(key);
  }
}

/// Декоратор, добавляющий логирование вызовов сервиса
class LoggingDataService extends DataServiceDecorator {
  LoggingDataService(super.inner);

  @override
  String fetchData(String key) {
    print('[LOG] Запрос fetchData("$key")');
    final result =
        super.fetchData(key); // вызов реального сервиса (внутри может быть другой декоратор)
    print('[LOG] Ответ получен для $key');
    return result;
  }
}

/// Декоратор, добавляющий кэширование результатов сервиса
class CachingDataService extends DataServiceDecorator {
  final Map<String, String> _cache = {};
  CachingDataService(super.inner);

  @override
  String fetchData(String key) {
    if (_cache.containsKey(key)) {
      print('Кеш: найден готовый результат для $key');
      return _cache[key]!;
    } else {
      print('Кеш: нет данных для $key, выполняется запрос...');
      final result = super.fetchData(key);
      _cache[key] = result; // сохраняем в кеш
      return result;
    }
  }
}
