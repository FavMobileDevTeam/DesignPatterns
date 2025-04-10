import 'package:flutter/cupertino.dart';

class PageBuilder {
  final List<Widget> _modules = [];

  PageBuilder setStoriesModule(Widget widget) {
    _modules.add(widget);

    return this;
  }

  PageBuilder setSettingsModule(Widget widget) {
    _modules.add(widget);

    return this;
  }

  PageBuilder setAccountModule(Widget widget) {
    _modules.add(widget);

    return this;
  }

  List<Widget> build() => _modules;
}
