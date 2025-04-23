void main() {
  final List list = [1, 2, 3, 4, 5];
  final iterator = list.iterator;
  while (iterator.moveNext()) {
    print(iterator.current);
  }
}
