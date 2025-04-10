import 'package:design_patterns/structural_patterns/adapter/our_class.dart';
import 'package:design_patterns/structural_patterns/adapter/some_library.dart';

class ClassAdapter extends SomeLibrary implements OurClass {
  @override
  void ourMethod(XML xml) {
    doSomething(xml.toJson());
  }
}
