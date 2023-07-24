import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/preview_part/service_preview_widget.dart';

class ServicePreviewPartWidget extends StatelessWidget {
  const ServicePreviewPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Text(
          SZodiac.of(context).servicePreviewZodiac,
          style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
        ),
        const SizedBox(
          height: 12.0,
        ),
        DottedBorder(
          color: theme.shadowColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(32.0),
          padding: const EdgeInsets.all(24.0),
          strokeWidth: 2.0,
          dashPattern: const [8.0, 8.0],
          child: const ServicePreviewWidget(),
        ),
      ],
    );
  }
}
