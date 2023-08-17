import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/generated/l10n.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(color: theme.canvasColor),
            padding: const EdgeInsets.all(16.0),
            child: AppElevatedButton(
                title: SZodiac.of(context).addServiceZodiac,
                onPressed: () =>
                    context.push(route: ZodiacEditService(serviceId: 3))))
      ],
    );
  }
}
