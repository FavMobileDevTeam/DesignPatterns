abstract interface class Component {
  void draw();
}

class CompositeComponent implements Component {
  final List<Component> _children = [];

  void add(Component graphic) {
    _children.add(graphic);
  }

  void remove(Component graphic) {
    _children.remove(graphic);
  }

  @override
  void draw() {
    for (var child in _children) {
      child.draw();
    }
  }
}

class Leaf implements Component {
  @override
  void draw() {
    print("Leaf Safe");
  }
}

void main() {
  CompositeComponent graphic = CompositeComponent();
  graphic.add(Leaf());
  graphic.add(Leaf());

  CompositeComponent graphic2 = CompositeComponent();
  graphic2.add(Leaf());

  graphic.add(graphic2);

  print("\nSafe Composite:");
  graphic.draw();
}
