class House {
  final int windows;
  final int doors;
  final bool hasGarage;

  House({
    required this.windows,
    required this.doors,
    required this.hasGarage,
  });

  @override
  String toString() => 'House(windows: $windows, doors: $doors, garage: $hasGarage)';
}

class HouseBuilder {
  int _windows = 0;
  int _doors = 0;
  bool _hasGarage = false;

  // Методы установки параметров без цепочки вызовов.
  void setWindows(int count) {
    _windows = count;
  }

  void setDoors(int count) {
    _doors = count;
  }

  void setGarage(bool value) {
    _hasGarage = value;
  }

  House build() {
    return House(
      windows: _windows,
      doors: _doors,
      hasGarage: _hasGarage,
    );
  }
}

void main() {
  final builder = HouseBuilder()
    ..setDoors(4)
    ..setGarage(true);

  final house = builder.build();

  print(house.toString());
}
