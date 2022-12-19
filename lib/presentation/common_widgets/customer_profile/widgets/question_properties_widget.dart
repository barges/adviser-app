import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class QuestionPropertiesWidget extends StatelessWidget {
  final List<String> properties;

  const QuestionPropertiesWidget({Key? key, required this.properties})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          color: Theme.of(context).hintColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).questionProperties.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0,
                  color: Theme.of(context).shadowColor,
                ),
          ),
          const SizedBox(height: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: properties
                .mapIndexed(
                  (element, index) => Padding(
                    padding: EdgeInsets.only(
                      bottom: index < properties.length - 1 ? 12.0 : 0.0,
                    ),
                    child: Text(
                      element,
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
