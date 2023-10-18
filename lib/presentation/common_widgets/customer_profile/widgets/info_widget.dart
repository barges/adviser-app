import 'package:flutter/material.dart';

import '../../../../app_constants.dart';

class InfoWidget extends StatelessWidget {
  final String title;
  final Widget info;

  const InfoWidget({Key? key, required this.title, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          border: Border.all(
            color: Theme.of(context).hintColor,
          ),
        ),
        child: Column(children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).shadowColor,
                ),
          ),
          const SizedBox(height: 8.0),
          info
        ]),
      ),
    );
  }
}
