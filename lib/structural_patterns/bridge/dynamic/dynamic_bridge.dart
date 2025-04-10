import 'package:design_patterns/structural_patterns/bridge/devices.dart';
import 'package:flutter/foundation.dart';

abstract class DynamicRemote {
  Device device;

  DynamicRemote({required this.device});

  @nonVirtual
  void setNewDevice(Device newDevice) {
    device = newDevice;
  }

  void power();

  void volumeUp();

  void volumeDown();
}

class BasicDynamicRemote extends DynamicRemote {
  BasicDynamicRemote({required super.device});

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
