// Это упрощенная версия из исходного кода Flutter
// @immutable
// abstract class ElementVisitor {
//   const ElementVisitor();

//   void visitInheritedElement(InheritedElement element);
//   void visitStatefulElement(StatefulElement element);
//   void visitStatelessElement(StatelessElement element);
//   void visitRenderObjectElement(RenderObjectElement element);
// Другие методы для разных типов элементов
// }

// abstract class Element {
//   void visitChildren(ElementVisitor visitor);
//   void visitAncestorElements(bool Function(Element ancestor) visitor);
// Другие методы
// }

// import 'package:flutter/material.dart';

//  [Element]
// void main() {
//   final element = Element(Text('Hello, World!'));
//   element.visitChildren(ElementVisitor());
// }
