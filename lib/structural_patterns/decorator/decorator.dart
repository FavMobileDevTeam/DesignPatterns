// Базовый интерфейс компонента
abstract class Coffee {
  String getDescription();
  double getCost();
}

// Конкретный компонент
class SimpleCoffee implements Coffee {
  @override
  String getDescription() {
    return 'Простой кофе';
  }

  @override
  double getCost() {
    return 2.0;
  }
}

// Базовый декоратор
abstract class CoffeeDecorator implements Coffee {
  final Coffee _coffee;

  CoffeeDecorator(this._coffee);

  @override
  String getDescription() {
    return _coffee.getDescription();
  }

  @override
  double getCost() {
    return _coffee.getCost();
  }
}

// Конкретные декораторы
class MilkDecorator extends CoffeeDecorator {
  MilkDecorator(super.coffee);

  @override
  String getDescription() {
    return '${super.getDescription()}, с молоком';
  }

  @override
  double getCost() {
    return super.getCost() + 0.5;
  }
}

class SugarDecorator extends CoffeeDecorator {
  SugarDecorator(super.coffee);

  @override
  String getDescription() {
    return '${super.getDescription()}, с сахаром';
  }

  @override
  double getCost() {
    return super.getCost() + 0.2;
  }
}

void main() {
  // Создаем простой кофе
  Coffee coffee = SimpleCoffee();
  print('${coffee.getDescription()} стоит: \$${coffee.getCost()}');

  // Добавляем молоко
  coffee = MilkDecorator(coffee);
  print('${coffee.getDescription()} стоит: \$${coffee.getCost()}');

  // Добавляем сахар
  coffee = SugarDecorator(coffee);
  print('${coffee.getDescription()} стоит: \$${coffee.getCost()}');
}
