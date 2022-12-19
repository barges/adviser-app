import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/constants.dart';

class AboutMeWidget extends StatelessWidget {
  final String title;
  final String description;

  const AboutMeWidget(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)), color: white),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: bodySmall),
              const Divider(),
              Text(description, style: displayLarge?.copyWith(color: color2))
            ]));
  }
}
