import 'package:design_patterns/structural_patterns/bridge/real_case/models.dart';
import 'package:flutter/material.dart';

class ServiceWidget extends StatelessWidget {
  final ServiceInterface interface;

  const ServiceWidget({super.key, required this.interface});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${interface.image} name'),
        Text('type'),
        Text('description'),
        Text('image'),
      ],
    );
  }
}
