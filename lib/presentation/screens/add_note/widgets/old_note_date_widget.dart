import 'package:flutter/material.dart';

import '../../../../extensions.dart';
import '../../../../app_constants.dart';

class OldNoteDateWidget extends StatelessWidget {
  final DateTime? updatedAt;

  const OldNoteDateWidget({Key? key, this.updatedAt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
        vertical: 12.0,
      ),
      child: Text(
        updatedAt!.oldNoteTime,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).shadowColor,
            ),
      ),
    );
  }
}
