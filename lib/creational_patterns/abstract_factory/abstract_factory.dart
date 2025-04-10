import 'package:design_patterns/creational_patterns/abstract_factory/buttons.dart';
import 'package:design_patterns/creational_patterns/abstract_factory/text_fields.dart';

abstract base class AbstractFactory {
  Button get button;
  TextFields get textField;
}

final class MaterialUIFactory extends AbstractFactory {
  @override
  Button get button => MaterialButton();

  @override
  TextFields get textField => MaterialTextField();
}

final class CupertinoUIFactory extends AbstractFactory {
  @override
  Button get button => IosButton();

  @override
  TextFields get textField => IosTextField();
}
