import 'dart:math' as math;

// Интерфейс посетителя, определяющий методы посещения для каждого типа элемента
abstract class ShapeVisitor {
  void visitCircle(Circle circle);
  void visitRectangle(Rectangle rectangle);
  void visitTriangle(Triangle triangle);
}

// Базовый абстрактный класс фигуры, который будет принимать посетителя
abstract class Shape {
  // Метод для принятия посетителя
  void accept(ShapeVisitor visitor);
}

// Конкретная реализация фигуры - Круг
class Circle implements Shape {
  final double radius;

  Circle(this.radius);

  @override
  void accept(ShapeVisitor visitor) {
    // Вызываем метод посетителя для этого конкретного типа
    visitor.visitCircle(this);
  }
}

// Конкретная реализация фигуры - Прямоугольник
class Rectangle implements Shape {
  final double width;
  final double height;

  Rectangle(this.width, this.height);

  @override
  void accept(ShapeVisitor visitor) {
    visitor.visitRectangle(this);
  }
}

// Конкретная реализация фигуры - Треугольник
class Triangle implements Shape {
  final double sideA;
  final double sideB;
  final double sideC;

  Triangle(this.sideA, this.sideB, this.sideC);

  @override
  void accept(ShapeVisitor visitor) {
    visitor.visitTriangle(this);
  }
}

// Конкретный посетитель для вычисления площади фигур
class AreaCalculator implements ShapeVisitor {
  double totalArea = 0;

  @override
  void visitCircle(Circle circle) {
    double area = math.pi * circle.radius * circle.radius;
    print('Площадь круга: $area');
    totalArea += area;
  }

  @override
  void visitRectangle(Rectangle rectangle) {
    double area = rectangle.width * rectangle.height;
    print('Площадь прямоугольника: $area');
    totalArea += area;
  }

  @override
  void visitTriangle(Triangle triangle) {
    // Используем формулу Герона для вычисления площади треугольника
    double s = (triangle.sideA + triangle.sideB + triangle.sideC) / 2;
    double area = math.sqrt(s * (s - triangle.sideA) * (s - triangle.sideB) * (s - triangle.sideC));
    print('Площадь треугольника: $area');
    totalArea += area;
  }

  double getTotalArea() {
    return totalArea;
  }
}

// Еще один конкретный посетитель для вычисления периметра фигур
class PerimeterCalculator implements ShapeVisitor {
  double totalPerimeter = 0;

  @override
  void visitCircle(Circle circle) {
    double perimeter = 2 * math.pi * circle.radius;
    print('Периметр круга: $perimeter');
    totalPerimeter += perimeter;
  }

  @override
  void visitRectangle(Rectangle rectangle) {
    double perimeter = 2 * (rectangle.width + rectangle.height);
    print('Периметр прямоугольника: $perimeter');
    totalPerimeter += perimeter;
  }

  @override
  void visitTriangle(Triangle triangle) {
    double perimeter = triangle.sideA + triangle.sideB + triangle.sideC;
    print('Периметр треугольника: $perimeter');
    totalPerimeter += perimeter;
  }

  double getTotalPerimeter() {
    return totalPerimeter;
  }
}

// Посетитель для отрисовки фигур
class DrawVisitor implements ShapeVisitor {
  @override
  void visitCircle(Circle circle) {
    print('Рисуем круг с радиусом ${circle.radius}');
  }

  @override
  void visitRectangle(Rectangle rectangle) {
    print('Рисуем прямоугольник ${rectangle.width}x${rectangle.height}');
  }

  @override
  void visitTriangle(Triangle triangle) {
    print(
        'Рисуем треугольник со сторонами ${triangle.sideA}, ${triangle.sideB}, ${triangle.sideC}');
  }
}

// Демонстрация использования паттерна
void main() {
  // Создаем набор фигур
  List<Shape> shapes = [Circle(5), Rectangle(4, 6), Triangle(3, 4, 5), Circle(3)];

  // Создаем посетителя для вычисления площадей
  AreaCalculator areaCalculator = AreaCalculator();

  // Создаем посетителя для вычисления периметров
  PerimeterCalculator perimeterCalculator = PerimeterCalculator();

  // Создаем посетителя для отрисовки
  DrawVisitor drawVisitor = DrawVisitor();

  // Проходим по всем фигурам и применяем к ним посетителей
  for (var shape in shapes) {
    // Вычисляем площадь
    shape.accept(areaCalculator);

    // Вычисляем периметр
    shape.accept(perimeterCalculator);

    // Отрисовываем фигуру
    shape.accept(drawVisitor);

    print('---');
  }

  // Выводим суммарные результаты
  print('Общая площадь всех фигур: ${areaCalculator.getTotalArea()}');
  print('Общий периметр всех фигур: ${perimeterCalculator.getTotalPerimeter()}');
}
