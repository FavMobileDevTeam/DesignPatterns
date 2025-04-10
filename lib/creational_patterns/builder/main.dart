import 'package:design_patterns/creational_patterns/builder/director_class.dart';
import 'package:design_patterns/creational_patterns/builder/page_builder.dart';
import 'package:flutter/material.dart';

void main() {
  final builder = PageBuilder();
  final director = DirectorClass(pageBuilder: builder);

  runApp(
    MaterialApp(
      home: BuilderExample(
        modules: director.buildPageWithSettings(),
      ),
    ),
  );
}

class BuilderExample extends StatelessWidget {
  final List<Widget> modules;

  const BuilderExample({super.key, required this.modules});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: modules,
        ),
      ),
    );
  }
}
