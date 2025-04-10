import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract base class TextFields {
  Widget get build;
}

final class MaterialTextField extends TextFields {
  @override
  Widget get build => TextField();
}

final class IosTextField extends TextFields {
  @override
  Widget get build => CupertinoTextField();
}
