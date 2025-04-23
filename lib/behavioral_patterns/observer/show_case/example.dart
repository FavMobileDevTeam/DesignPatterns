import 'package:design_patterns/behavioral_patterns/observer/show_case/model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ObserverPatternDemo());
}

// Виджет для демонстрации работы паттерна
class ObserverPatternDemo extends StatefulWidget {
  const ObserverPatternDemo({super.key});

  @override
  State<ObserverPatternDemo> createState() => _ObserverPatternDemoState();
}

class _ObserverPatternDemoState extends State<ObserverPatternDemo> {
  final NewsAgency _newsAgency = NewsAgency();
  final NewsChannel _channel1 = NewsChannel('Канал 1');
  final NewsChannel _channel2 = NewsChannel('Канал 2');
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newsAgency.attach(_channel1);
    _newsAgency.attach(_channel2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _publishNews() {
    if (_controller.text.isNotEmpty) {
      _newsAgency.setNews(_controller.text);
      setState(() {});
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Демонстрация паттерна Наблюдатель'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Введите новость',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _publishNews,
                child: const Text('Опубликовать новость'),
              ),
              const SizedBox(height: 32),
              Text(
                '${_channel1.name}: ${_channel1.lastNews}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                '${_channel2.name}: ${_channel2.lastNews}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
