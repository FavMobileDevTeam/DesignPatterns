class MenuItem {
  final String title;
  final List<MenuItem> children;
  MenuItem(this.title, [this.children = const []]);
}

abstract class Iterator<T> {
  bool moveNext();
  T get current;
}

class MenuIterator implements Iterator<MenuItem> {
  final List<MenuItem> _flatList = [];
  int _index = -1;

  MenuIterator(MenuItem root) {
    _flatten(root);
  }

  void _flatten(MenuItem item) {
    _flatList.add(item);
    for (var child in item.children) {
      _flatten(child);
    }
  }

  @override
  bool moveNext() {
    if (_index + 1 >= _flatList.length) return false;
    _index++;
    return true;
  }

  @override
  MenuItem get current => _flatList[_index];
}

void main() {
  final root = MenuItem("Root", [
    MenuItem("Settings", [MenuItem("Security"), MenuItem("Privacy")]),
    MenuItem("Help"),
  ]);

  final iterator = MenuIterator(root);
  while (iterator.moveNext()) {
    print(iterator.current.title);
  }
}
