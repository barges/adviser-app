import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';

class CountryCodeWidget extends StatelessWidget {
  final String code;
  final String country;
  final VoidCallback? onTap;

  const CountryCodeWidget({
    Key? key,
    required this.code,
    required this.country,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            bottom: 4.0,
          ),
          child: Text(
            SZodiac.of(context).codeZodiac,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              color: Theme.of(context).hintColor,
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
              height: AppConstants.textFieldsHeight - 3,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppConstants.buttonRadius - 1),
                color: Theme.of(context).canvasColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Text(code,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            top: 2.0,
          ),
          child: Text(
            country,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.0,
                  color: Theme.of(context).shadowColor,
                ),
          ),
        ),
      ],
    );
  }
}
