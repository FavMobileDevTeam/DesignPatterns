import 'package:design_patterns/behavioral_patterns/mediator/real_case/models.dart';
import 'package:flutter/material.dart';

// Использование в UI Flutter для смены режимов
class SmartHomeScreen extends StatefulWidget {
  const SmartHomeScreen({super.key});

  @override
  State<SmartHomeScreen> createState() => _SmartHomeScreenState();
}

class _SmartHomeScreenState extends State<SmartHomeScreen> {
  late ConcreteSmartHomeMediator _mediator;
  late SecuritySystem _securitySystem;
  late LightingSystem _lightingSystem;
  late TemperatureControl _temperatureControl;
  String _currentMode = "Не выбран";

  @override
  void initState() {
    super.initState();

    _initializeSmartHome();
  }

  void _initializeSmartHome() {
    // Создаем посредника и устройства
    _mediator = ConcreteSmartHomeMediator();
    _securitySystem = SecuritySystem();
    _lightingSystem = LightingSystem();
    _temperatureControl = TemperatureControl();

    // Регистрируем устройства через посредника
    _mediator.registerDevice(_securitySystem);
    _mediator.registerDevice(_lightingSystem);
    _mediator.registerDevice(_temperatureControl);
  }

  void _changeMode(String mode) {
    setState(() {
      _currentMode = mode.replaceAll('_MODE', '');
    });
    _securitySystem.changeMode(mode);
  }

  void _showEventLog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Журнал событий'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _mediator.getEventLog().map((event) => Text(event)).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Умный дом'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _showEventLog,
            tooltip: 'Показать журнал событий',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Текущий режим: $_currentMode',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _changeMode('HOME_MODE'),
              icon: const Icon(Icons.home),
              label: const Text('Режим "Дома"'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _changeMode('AWAY_MODE'),
              icon: const Icon(Icons.directions_walk),
              label: const Text('Режим "Не дома"'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _changeMode('NIGHT_MODE'),
              icon: const Icon(Icons.nightlight_round),
              label: const Text('Режим "Ночь"'),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _lightingSystem.toggleMasterBedroom(),
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('Переключить свет в спальне'),
            ),
          ],
        ),
      ),
    );
  }
}

// Пример приложения
class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SmartHomeScreen(),
    );
  }
}

void main() {
  runApp(const SmartHomeApp());
}
