abstract class Device {
  bool isOn;
  int volume;

  Device({this.isOn = false, this.volume = 10});

  void togglePower();
  void setVolume(int volume);
}

// Конкретная реализация: телевизор.
class TV implements Device {
  @override
  bool isOn;
  @override
  int volume;

  TV({this.isOn = false, this.volume = 10});

  @override
  void togglePower() {
    isOn = !isOn;
    print('Телевизор ${isOn ? "включён" : "выключен"}');
  }

  @override
  void setVolume(int volume) {
    this.volume = volume;
    print('Громкость телевизора: $volume');
  }
}

class Radio implements Device {
  @override
  bool isOn;
  @override
  int volume;

  Radio({this.isOn = false, this.volume = 10});

  @override
  void togglePower() {
    isOn = !isOn;
    print('Телевизор ${isOn ? "включён" : "выключен"}');
  }

  @override
  void setVolume(int volume) {
    this.volume = volume;
    print('Громкость телевизора: $volume');
  }
}
