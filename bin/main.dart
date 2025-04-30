import 'package:design_patterns/behavioral_patterns/strategy/show_case/example.dart';

void main() {
  // Create shopping cart
  final cart = ShoppingCart();

  // Add items
  cart.addItem(100);
  cart.addItem(50);

  // Pay with credit card
  cart.setPaymentStrategy(CreditCardPayment('1234-5678-9012-3456', '123', '12/25'));
  cart.checkout();

  // Pay with PayPal
  cart.setPaymentStrategy(PayPalPayment('example@email.com', 'password123'));
  cart.checkout();
}
