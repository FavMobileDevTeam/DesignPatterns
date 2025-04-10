class EagerSingleton {
  // Экземпляр создаётся при загрузке класса.
  static final EagerSingleton _instance = EagerSingleton._internal();

  // Фабричный конструктор возвращает заранее созданный экземпляр.
  factory EagerSingleton() {
    return _instance;
  }

  // Приватный конструктор, чтобы предотвратить создание новых экземпляров.
  EagerSingleton._internal();

  void someMethod() {
    print("EagerSingleton: вызов метода");
  }
}
