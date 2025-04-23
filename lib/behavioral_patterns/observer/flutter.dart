import 'package:flutter/material.dart';

void main() {
  ValueNotifier<int> valueNotifier = ValueNotifier(0);
  valueNotifier.addListener(() {
    print(valueNotifier.value);
  });
  valueNotifier.value = 1;
  valueNotifier.value = 2;
  valueNotifier.value = 3;
}
