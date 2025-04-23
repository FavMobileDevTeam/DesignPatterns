// Пример использования
import 'package:design_patterns/behavioral_patterns/template_method/real_case/template.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Template Method Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шаблонный метод'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ApiDataScreen(
                      title: 'Данные из API',
                      apiUrl: 'https://example.com/api/data',
                    ),
                  ),
                );
              },
              child: const Text('Загрузить данные из API'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ApiDataScreen(
                      title: 'Ошибка API',
                      apiUrl: 'https://example.com/api/error',
                    ),
                  ),
                );
              },
              child: const Text('Симулировать ошибку API'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LocalDataScreen(
                      title: 'Локальные данные',
                      storagePath: '/data/local',
                    ),
                  ),
                );
              },
              child: const Text('Загрузить локальные данные'),
            ),
          ],
        ),
      ),
    );
  }
}
