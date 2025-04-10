import 'package:design_patterns/creational_patterns/abstract_factory/abstract_factory.dart';
import 'package:flutter/material.dart';

void main() {
  final materialFactory = MaterialUIFactory();
  final cupertinofactory = CupertinoUIFactory();

  runApp(
    MaterialApp(
      home: AbstractFactoryExample(factory: materialFactory),
    ),
  );
}

class AbstractFactoryExample extends StatelessWidget {
  final AbstractFactory factory;

  const AbstractFactoryExample({super.key, required this.factory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            factory.textField.build,
            const SizedBox(height: 12),
            factory.button.build,
          ],
        ),
      ),
    );
  }
}
