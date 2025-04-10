class Prototype {
  final int number;
  final List<String> someList;

  Prototype({required this.number, required this.someList});

  Prototype clone() {
    return Prototype(
      number: number,
      someList: someList,
    );
  }

  Prototype deepClone() {
    return Prototype(
      number: number,
      someList: List<String>.from(someList),
    );
  }

  Prototype cloneWithParams({
    int? number,
    List<String>? someList,
  }) {
    return Prototype(
      number: number ?? this.number,
      someList: someList ?? this.someList,
    );
  }
}
