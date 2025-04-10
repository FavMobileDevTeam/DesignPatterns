import 'package:design_patterns/creational_patterns/factory_method/product_type.dart';

abstract base class Account {
  ProductType get productType;

  void printType() {
    productType.printType();
  }
}

final class DefaultAccount extends Account {
  @override
  ProductType get productType => DefaultProductType();
}

final class DepositAccount extends Account {
  @override
  ProductType get productType => DepositProductType();
}

final class CreditAccount extends Account {
  @override
  ProductType get productType => CreditProductType();
}

void main() {
  final defaultAcc = DefaultAccount();
  final creditAcc = CreditAccount();
  final depositAcc = DepositAccount();

  _printType(depositAcc);
  _printType(creditAcc);
  _printType(defaultAcc);
}

void _printType(Account account) {
  account.printType();
}
