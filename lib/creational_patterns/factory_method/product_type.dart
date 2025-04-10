abstract base class ProductType {
  void printType();
}

final class DepositProductType extends ProductType {
  @override
  void printType() {
    print('Deposit type');
  }
}

final class CreditProductType extends ProductType {
  @override
  void printType() {
    print('Credit type');
  }
}

final class DefaultProductType extends ProductType {
  @override
  void printType() {
    print('Default type');
  }
}
