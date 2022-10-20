import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/constants.dart';

class AboutMeWidget extends StatelessWidget {
  final double rating;
  final String votesNumber;
  final List<SessionsTypes> title;
  final String description;

  const AboutMeWidget(
      {Key? key,
      required this.rating,
      required this.votesNumber,
      required this.title,
      required this.description})
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
              Row(
                children: [
                  Text(
                    '$rating',
                    style: bodyMedium,
                  ),
                  const SizedBox(width: 3.0),
                  Assets.vectors.starFilled.svg(height: 14.0, width: 14.0),
                  const SizedBox(width: 9.0),
                  Text('/  $votesNumber ${S.of(context).peopleHelped}',
                      style: displayLarge?.copyWith(color: color2))
                ],
              ),
              Text(
                  title
                      .map((e) => e.sessionName)
                      .toList()
                      .reduce((value, element) => '$value, $element'),
                  style: bodySmall),
              const Divider(),
              Text(description, style: displayLarge?.copyWith(color: color2))
            ]));
  }
}
