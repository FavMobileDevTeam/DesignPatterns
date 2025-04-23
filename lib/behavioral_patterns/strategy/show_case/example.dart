// Strategy interface
abstract class PaymentStrategy {
  void pay(double amount);
}

// Concrete strategies
class CreditCardPayment implements PaymentStrategy {
  final String cardNumber;
  final String cvv;
  final String expiryDate;

  CreditCardPayment(this.cardNumber, this.cvv, this.expiryDate);

  @override
  void pay(double amount) {
    print('Paid \$$amount using Credit Card');
    print('Card Details: $cardNumber, $cvv, $expiryDate');
  }
}

class PayPalPayment implements PaymentStrategy {
  final String email;
  final String password;

  PayPalPayment(this.email, this.password);

  @override
  void pay(double amount) {
    print('Paid \$$amount using PayPal');
    print('PayPal Account: $email');
  }
}

// Context
class ShoppingCart {
  late PaymentStrategy _paymentStrategy;
  final List<double> _prices = [];

  void setPaymentStrategy(PaymentStrategy strategy) {
    _paymentStrategy = strategy;
  }

  void addItem(double price) {
    _prices.add(price);
  }

  void checkout() {
    double total = _prices.reduce((a, b) => a + b);
    _paymentStrategy.pay(total);
  }
}

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
