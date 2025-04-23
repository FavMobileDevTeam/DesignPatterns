// Интерфейс для устройств умного дома
// ignore_for_file: avoid_print

abstract class SmartHomeDevice {
  void setMediator(SmartHomeMediator mediator);
  String getName();
  void handleEvent(String event);
}

// Интерфейс посредника
abstract class SmartHomeMediator {
  void notify(SmartHomeDevice sender, String event);
  void registerDevice(SmartHomeDevice device);
  void unregisterDevice(SmartHomeDevice device);
}

// Конкретный посредник для управления умным домом
class ConcreteSmartHomeMediator implements SmartHomeMediator {
  final Map<Type, SmartHomeDevice> _devices = {};
  final List<String> _eventLog = [];

  void addEventToLog(String event) {
    _eventLog.add('${DateTime.now()}: $event');
  }

  List<String> getEventLog() => List.unmodifiable(_eventLog);

  @override
  void registerDevice(SmartHomeDevice device) {
    _devices[device.runtimeType] = device;
    device.setMediator(this);
    addEventToLog('Устройство ${device.getName()} зарегистрировано');
  }

  @override
  void unregisterDevice(SmartHomeDevice device) {
    _devices.remove(device.runtimeType);
    addEventToLog('Устройство ${device.getName()} удалено');
  }

  @override
  void notify(SmartHomeDevice sender, String event) {
    addEventToLog('${sender.getName()} отправил событие: $event');

    for (var device in _devices.values) {
      if (device != sender) {
        device.handleEvent(event);
      }
    }
  }
}

// Конкретные устройства
class LightingSystem implements SmartHomeDevice {
  late SmartHomeMediator _mediator;
  bool _isOn = false;
  double _brightness = 1.0;

  @override
  void setMediator(SmartHomeMediator mediator) => _mediator = mediator;

  @override
  String getName() => 'Система освещения';

  @override
  void handleEvent(String event) {
    switch (event) {
      case 'AWAY_MODE':
        turnOffAllLights();
        break;
      case 'NIGHT_MODE':
        dimLights();
        break;
      case 'HOME_MODE':
        setDefaultLighting();
        break;
    }
  }

  void turnOffAllLights() {
    _isOn = false;
    _brightness = 0;
    print('Все светильники выключены');
  }

  void dimLights() {
    _isOn = true;
    _brightness = 0.3;
    print('Свет приглушен до ${(_brightness * 100).toInt()}%');
  }

  void setDefaultLighting() {
    _isOn = true;
    _brightness = 1.0;
    print('Установлено стандартное освещение (100%)');
  }

  void toggleMasterBedroom() {
    _isOn = !_isOn;
    print('Переключение света в главной спальне: ${_isOn ? "включен" : "выключен"}');
    _mediator.notify(this, 'MASTER_BEDROOM_LIGHT_TOGGLED');
  }
}

class TemperatureControl implements SmartHomeDevice {
  late SmartHomeMediator _mediator;
  double _currentTemp = 22.0;

  @override
  void setMediator(SmartHomeMediator mediator) => _mediator = mediator;

  @override
  String getName() => 'Система контроля температуры';

  @override
  void handleEvent(String event) {
    switch (event) {
      case 'AWAY_MODE':
        setEcoMode();
        break;
      case 'NIGHT_MODE':
        setSleepingTemperature();
        break;
      case 'HOME_MODE':
        setComfortTemperature();
        break;
    }
  }

  void setEcoMode() {
    _setTemperature(18.0);
    print('Установлен экономичный режим температуры (18°C)');
  }

  void setSleepingTemperature() {
    _setTemperature(20.0);
    print('Установлена температура для сна (20°C)');
  }

  void setComfortTemperature() {
    _setTemperature(22.0);
    print('Установлена комфортная температура (22°C)');
  }

  void _setTemperature(double temp) {
    _currentTemp = temp;
    _mediator.notify(this, 'TEMPERATURE_CHANGED_${temp.toStringAsFixed(1)}');
  }

  double getCurrentTemperature() => _currentTemp;
}

class SecuritySystem implements SmartHomeDevice {
  late SmartHomeMediator _mediator;
  SecurityMode currentMode = SecurityMode.disabled;

  @override
  void setMediator(SmartHomeMediator mediator) => _mediator = mediator;

  @override
  String getName() => 'Система безопасности';

  @override
  void handleEvent(String event) {
    switch (event) {
      case 'AWAY_MODE':
        activateFullSecurity();
        break;
      case 'NIGHT_MODE':
        activatePerimeterSecurity();
        break;
      case 'HOME_MODE':
        deactivate();
        break;
    }
  }

  void activateFullSecurity() {
    currentMode = SecurityMode.full;
    print('Полная система безопасности активирована');
    _mediator.notify(this, 'SECURITY_FULL');
  }

  void activatePerimeterSecurity() {
    currentMode = SecurityMode.perimeter;
    print('Периметр защиты активирован');
    _mediator.notify(this, 'SECURITY_PERIMETER');
  }

  void deactivate() {
    currentMode = SecurityMode.disabled;
    print('Система безопасности отключена');
    _mediator.notify(this, 'SECURITY_DISABLED');
  }

  void changeMode(String mode) {
    _mediator.notify(this, mode);
  }
}

enum SecurityMode { disabled, perimeter, full }
