import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class QuestionPropertiesWidget extends StatelessWidget {
  final List<String> properties;

  const QuestionPropertiesWidget({Key? key, required this.properties})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          color: Theme.of(context).hintColor,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          S.of(context).preferredTopics.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 13.0,
                color: Theme.of(context).shadowColor,
              ),
        ),
        const SizedBox(height: 10.0),
        ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => Text(
                  properties[index],
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
            separatorBuilder: (_, __) => const SizedBox(height: 12.0),
            itemCount: properties.length)
      ]),
    );
  }
}
