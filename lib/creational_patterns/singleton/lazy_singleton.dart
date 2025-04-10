class LazySingleton {
  static LazySingleton? _instance;

  LazySingleton._internal();

  // Фабричный конструктор создает экземпляр только при первом вызове.
  factory LazySingleton() {
    _instance ??= LazySingleton._internal();
    return _instance!;
  }

  void someMethod() {
    print("LazySingleton: вызов метода");
  }
}
