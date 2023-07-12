import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/services_messages/box_decoration_widget.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BoxDecorationWidget(
      child: Row(
        children: [
          Assets.zodiac.vectors.infoSquareIcon.svg(color: theme.shadowColor),
          const SizedBox(
            width: 8.0,
          ),
          Flexible(
            child: Text(
              SZodiac.of(context).youCanEasilyAccessTheseTemplates,
              maxLines: 2,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
