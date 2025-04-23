// Интерфейс для доступа к данным
abstract class DataService {
  Future<String> getData(String key);
}

// Реальный сервис, который медленно получает данные
class RealDataService implements DataService {
  @override
  Future<String> getData(String key) async {
    // Имитируем долгую загрузку данных
    await Future.delayed(Duration(seconds: 2));
    return 'Данные для ключа: $key';
  }
}

// Прокси с кэшированием
class CachedDataServiceProxy implements DataService {
  final RealDataService _realService = RealDataService();
  final Map<String, String> _cache = {};

  @override
  Future<String> getData(String key) async {
    // Проверяем наличие данных в кэше
    if (_cache.containsKey(key)) {
      print('Получение данных из кэша для ключа: $key');
      return _cache[key]!;
    }

    // Если данных в кэше нет, получаем их из реального сервиса
    print('Кэш пуст. Загрузка данных из сервиса для ключа: $key');
    final data = await _realService.getData(key);

    // Сохраняем данные в кэш
    _cache[key] = data;
    return data;
  }

  // Метод для очистки кэша
  void clearCache() {
    _cache.clear();
    print('Кэш очищен');
  }
}

void main() async {
  final proxy = CachedDataServiceProxy();

  // Первый запрос - данные будут загружены из сервиса
  print('Первый запрос:');
  var data = await proxy.getData('user-1');
  print(data);

  // Второй запрос к тем же данным - будут получены из кэша
  print('\nВторой запрос:');
  data = await proxy.getData('user-1');
  print(data);

  // Запрос новых данных
  print('\nЗапрос других данных:');
  data = await proxy.getData('user-2');
  print(data);

  // Очистка кэша
  print('\nОчистка кэша');
  proxy.clearCache();

  // После очистки кэша данные будут загружены заново
  print('\nЗапрос после очистки кэша:');
  data = await proxy.getData('user-1');
  print(data);
}
