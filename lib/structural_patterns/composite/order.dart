class Order implements OrderComponent {
  final List<Product> products;

  Order({required this.products});

  @override
  int getPrice() {
    int totalPrice = 0;
    for (var product in products) {
      totalPrice += product.getPrice();
    }
    return totalPrice;
  }
}

class Product implements OrderComponent {
  final List<Ingredient> ingredients;

  Product({required this.ingredients});

  @override
  int getPrice() {
    int totalPrice = 0;
    for (var ingredient in ingredients) {
      totalPrice += ingredient.getPrice();
    }
    return totalPrice;
  }
}

class Ingredient implements OrderComponent {
  final int price;

  Ingredient({required this.price});

  @override
  int getPrice() {
    return price;
  }
}

abstract interface class OrderComponent {
  int getPrice();
}

class OrderComposite implements OrderComponent {
  final List<OrderComponent> _components = [];

  void add(OrderComponent component) {
    _components.add(component);
  }

  @override
  int getPrice() {
    int totalPrice = 0;
    for (var component in _components) {
      totalPrice += component.getPrice();
    }
    return totalPrice;
  }
}

void main() {
  // Create ingredients
  var cheese = Ingredient(price: 100);
  var tomato = Ingredient(price: 50);
  var dough = Ingredient(price: 150);

  // Create a pizza product with ingredients
  var pizza = Product(ingredients: [cheese, tomato, dough]);

  // Create another product
  var cola = Product(ingredients: [
    Ingredient(price: 80),
  ]);

  // Create composite order
  var order = OrderComposite();
  order.add(pizza);
  order.add(cola);

  // Calculate total price
  print('Total order price: ${order.getPrice()}'); // Should print 380
}
