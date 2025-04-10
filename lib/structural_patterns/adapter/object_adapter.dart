import 'package:design_patterns/structural_patterns/adapter/our_class.dart';
import 'package:design_patterns/structural_patterns/adapter/some_library.dart';

class ObjectAdapter implements OurClass {
  final SomeLibrary someLibrary;

  ObjectAdapter({required this.someLibrary});

  @override
  void ourMethod(XML xml) {
    final json = xml.toJson();

    someLibrary.doSomething(json);
  }
}
