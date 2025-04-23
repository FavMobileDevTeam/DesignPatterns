import 'package:flutter/material.dart';

// Component interface
abstract class UIComponent {
  Widget build();
}

// Composite component that can contain other components
class ContainerComponent implements UIComponent {
  final List<UIComponent> _children = [];
  final Color backgroundColor;

  ContainerComponent({this.backgroundColor = Colors.white});

  void addComponent(UIComponent component) {
    _children.add(component);
  }

  void removeComponent(UIComponent component) {
    _children.remove(component);
  }

  @override
  Widget build() {
    return Container(
      color: backgroundColor,
      child: Column(
        children: _children.map((component) => component.build()).toList(),
      ),
    );
  }
}

// Leaf components
class TextComponent implements UIComponent {
  final String text;

  TextComponent(this.text);

  @override
  Widget build() {
    return Text(text);
  }
}

class ButtonComponent implements UIComponent {
  final String label;
  final VoidCallback onPressed;

  ButtonComponent(this.label, this.onPressed);

  @override
  Widget build() {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

// Example usage
class CompositeWidgetExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Create root container
    final rootContainer = ContainerComponent(backgroundColor: Colors.grey[200]!);

    // Add some text components
    rootContainer.addComponent(TextComponent('Welcome to Composite Pattern Demo'));
    rootContainer.addComponent(TextComponent('This is a simple example'));

    // Create a nested container
    final nestedContainer = ContainerComponent(backgroundColor: Colors.white);
    nestedContainer.addComponent(ButtonComponent('Click me!', () {
      print('Button clicked!');
    }));
    nestedContainer.addComponent(TextComponent('Nested component'));

    // Add nested container to root
    rootContainer.addComponent(nestedContainer);

    return Scaffold(
      appBar: AppBar(title: Text('Composite Pattern Example')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: rootContainer.build(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: CompositeWidgetExample()));
}
