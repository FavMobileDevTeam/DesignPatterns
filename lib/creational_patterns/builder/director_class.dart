import 'package:design_patterns/creational_patterns/builder/page_builder.dart';
import 'package:flutter/cupertino.dart';

class DirectorClass {
  final PageBuilder pageBuilder;

  DirectorClass({required this.pageBuilder});

  List<Widget> buildStandartPage() {
    final modules = pageBuilder
        .setAccountModule(Text('Standart account module'))
        .setStoriesModule(Text('stories'));

    return modules.build();
  }

  List<Widget> buildPageWithSettings() {
    final modules = pageBuilder
      ..setSettingsModule(Text('settings module'))
      ..setAccountModule(Text('Standart account module'))
      ..setStoriesModule(Text('stories'));

    return modules.build();
  }
}
