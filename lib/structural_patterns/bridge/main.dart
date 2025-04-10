import 'package:design_patterns/structural_patterns/bridge/devices.dart';
import 'package:design_patterns/structural_patterns/bridge/dynamic/dynamic_bridge.dart';
import 'package:design_patterns/structural_patterns/bridge/static/static_bridge.dart';

void main() {
  final tv = TV();

  final staticRemote = BasicRemote(tv);

  staticRemote.power();
  staticRemote.volumeUp();
  staticRemote.volumeDown();

  final dynamicRemote = BasicDynamicRemote(device: tv);

  dynamicRemote.power();
  dynamicRemote.volumeUp();
  dynamicRemote.volumeDown();

  dynamicRemote.setNewDevice(Radio());

  dynamicRemote.power();
  dynamicRemote.volumeUp();
  dynamicRemote.volumeDown();
}
