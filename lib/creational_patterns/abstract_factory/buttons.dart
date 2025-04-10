import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Button {
  Widget get build;
}

final class MaterialButton extends Button {
  @override
  Widget get build => ElevatedButton(
        onPressed: () {},
        child: Text('Material button'),
      );
}

final class IosButton extends Button {
  @override
  Widget get build => CupertinoButton(
        child: Text('Ios button'),
        onPressed: () {},
      );
}
