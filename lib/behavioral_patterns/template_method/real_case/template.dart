import 'package:flutter/material.dart';

/// Абстрактный базовый класс с шаблонным методом
abstract class BaseDataScreen<T> extends StatefulWidget {
  final String title;

  const BaseDataScreen({super.key, required this.title});

  @override
  BaseDataScreenState<T> createState();
}

/// Абстрактный класс состояния
abstract class BaseDataScreenState<T> extends State<BaseDataScreen<T>> {
  bool _isLoading = true;
  T? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    _processData();
  }

  /// Шаблонный метод, определяющий скелет алгоритма
  Future<void> _processData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Шаг 1: Загрузка данных (переопределяется в подклассах)
      final data = await loadData();

      // Шаг 2: Валидация данных (может быть переопределена)
      validateData(data);

      // Шаг 3: Обработка данных (может быть переопределена)
      final processedData = processData(data);

      // Шаг 4: Сохранение результата
      setState(() {
        _data = processedData;
        _isLoading = false;
      });

      // Шаг 5: Пост-обработка (опционально)
      onDataProcessed(processedData);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  /// Абстрактный метод загрузки данных (должен быть реализован в подклассах)
  Future<T> loadData();

  /// Валидация данных (опционально можно переопределить)
  void validateData(T data) {
    // По умолчанию ничего не делает
  }

  /// Обработка данных (опционально можно переопределить)
  T processData(T data) {
    return data; // По умолчанию возвращает данные без изменений
  }

  /// Пост-обработка (опционально можно переопределить)
  void onDataProcessed(T data) {
    // По умолчанию ничего не делает
  }

  /// Метод для отображения данных (должен быть реализован в подклассах)
  Widget buildContent(T data);

  /// Метод для отображения ошибки (можно переопределить)
  Widget buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text('Ошибка: $error', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _processData(),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  /// Метод для отображения индикатора загрузки (можно переопределить)
  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? buildLoading()
          : (_error != null ? buildError(_error!) : buildContent(_data as T)),
    );
  }
}

// Конкретная реализация для загрузки данных из API
class ApiDataScreen extends BaseDataScreen<List<String>> {
  final String apiUrl;

  const ApiDataScreen({
    super.key,
    required super.title,
    required this.apiUrl,
  });

  @override
  ApiDataScreenState createState() => ApiDataScreenState();
}

class ApiDataScreenState extends BaseDataScreenState<List<String>> {
  @override
  Future<List<String>> loadData() async {
    // Имитация запроса к API
    await Future.delayed(const Duration(seconds: 2));

    // В реальном приложении здесь был бы HTTP-запрос
    if ((widget as ApiDataScreen).apiUrl.contains('error')) {
      throw Exception('Ошибка при загрузке данных с сервера');
    }

    return ['Элемент 1', 'Элемент 2', 'Элемент 3'];
  }

  @override
  void validateData(List<String> data) {
    if (data.isEmpty) {
      throw Exception('Список данных пуст');
    }
  }

  @override
  List<String> processData(List<String> data) {
    // Добавляем к каждому элементу префикс
    return data.map((item) => 'API: $item').toList();
  }

  @override
  Widget buildContent(List<String> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(data[index]),
          leading: const Icon(Icons.cloud_download),
        );
      },
    );
  }
}

// Конкретная реализация для загрузки данных из локального хранилища
class LocalDataScreen extends BaseDataScreen<Map<String, dynamic>> {
  final String storagePath;

  const LocalDataScreen({
    super.key,
    required super.title,
    required this.storagePath,
  });

  @override
  LocalDataScreenState createState() => LocalDataScreenState();
}

class LocalDataScreenState extends BaseDataScreenState<Map<String, dynamic>> {
  @override
  Future<Map<String, dynamic>> loadData() async {
    // Имитация загрузки из локального хранилища
    await Future.delayed(const Duration(seconds: 1));

    // В реальном приложении здесь было бы чтение из SharedPreferences или файла
    return {
      'name': 'Пользователь',
      'age': 30,
      'preferences': ['Спорт', 'Музыка', 'Программирование']
    };
  }

  @override
  Widget buildContent(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Имя: ${data['name']}', style: const TextStyle(fontSize: 18)),
          Text('Возраст: ${data['age']}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          const Text('Интересы:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...(data['preferences'] as List<dynamic>).map((item) => Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.check, size: 16),
                    const SizedBox(width: 8),
                    Text(item.toString()),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget buildLoading() {
    // Переопределяем индикатор загрузки
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Загрузка локальных данных...'),
          SizedBox(height: 16),
          LinearProgressIndicator(),
        ],
      ),
    );
  }
}
