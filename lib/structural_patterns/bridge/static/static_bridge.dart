// Абстракция: определяем абстрактный класс для пульта.
import 'package:design_patterns/structural_patterns/bridge/devices.dart';

abstract class Remote {
  final Device device;

  Remote(this.device);

  void power();

  void volumeUp();

  void volumeDown();
}

// Конкретная абстракция: базовый пульт дистанционного управления.
class BasicRemote extends Remote {
  BasicRemote(super.device);

  @override
  void power() {
    print('Переключение питания');
    device.togglePower();
  }

  @override
  void volumeUp() {
    print('Увеличение громкости');
    device.setVolume(device.volume + 1);
  }

  @override
  void volumeDown() {
    print('Уменьшение громкости');
    device.setVolume(device.volume - 1);
  }
}
