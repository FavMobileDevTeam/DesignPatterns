import 'package:flutter/material.dart';

// Интерфейс посетителя
abstract class ShapeVisitor {
  void visitCircle(Circle circle);
  void visitRectangle(Rectangle rectangle);
  void visitTriangle(Triangle triangle);
}

// Базовый класс фигуры
abstract class Shape {
  void accept(ShapeVisitor visitor);
}

// Конкретные фигуры
class Circle extends Shape {
  final double radius;
  Circle(this.radius);

  @override
  void accept(ShapeVisitor visitor) {
    visitor.visitCircle(this);
  }
}

class Rectangle extends Shape {
  final double width;
  final double height;
  Rectangle(this.width, this.height);

  @override
  void accept(ShapeVisitor visitor) {
    visitor.visitRectangle(this);
  }
}

class Triangle extends Shape {
  final double base;
  final double height;
  Triangle(this.base, this.height);

  @override
  void accept(ShapeVisitor visitor) {
    visitor.visitTriangle(this);
  }
}

// Конкретный посетитель для вычисления площади
class AreaCalculator implements ShapeVisitor {
  double totalArea = 0;

  @override
  void visitCircle(Circle circle) {
    totalArea += 3.14 * circle.radius * circle.radius;
  }

  @override
  void visitRectangle(Rectangle rectangle) {
    totalArea += rectangle.width * rectangle.height;
  }

  @override
  void visitTriangle(Triangle triangle) {
    totalArea += 0.5 * triangle.base * triangle.height;
  }
}

// Пример использования
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitor Pattern Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Создаем набор фигур
    final shapes = [Circle(5), Rectangle(4, 6), Triangle(3, 8)];

    // Создаем калькулятор площади
    final areaCalculator = AreaCalculator();

    // Вычисляем общую площадь
    for (var shape in shapes) {
      shape.accept(areaCalculator);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Паттерн Посетитель'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Фигуры:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text('Круг (радиус: 5)'),
            Text('Прямоугольник (4 x 6)'),
            Text('Треугольник (основание: 3, высота: 8)'),
            const SizedBox(height: 20),
            Text(
              'Общая площадь: ${areaCalculator.totalArea.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
