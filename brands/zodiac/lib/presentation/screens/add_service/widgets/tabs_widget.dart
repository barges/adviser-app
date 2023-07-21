import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';

enum ServiceTabType {
  online,
  offline;
}

class TabsWidget extends StatelessWidget {
  const TabsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ServiceTabType selectedTabIndex =
        context.select((AddServiceCubit cubit) => cubit.state.selectedTabIndex);

    return Row(
      children: [
        Expanded(
          child: TabWidget(
            title: SZodiac.of(context).onlineServiceTabZodiac,
            isSelected: selectedTabIndex == ServiceTabType.online,
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: TabWidget(
            title: SZodiac.of(context).offlineServiceTabZodiac,
            isSelected: selectedTabIndex == ServiceTabType.offline,
          ),
        ),
      ],
    );
  }
}

class TabWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? unselectedColor;

  const TabWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    this.onTap,
    this.unselectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColorLight
              : unselectedColor ?? theme.canvasColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        padding: const EdgeInsets.symmetric(vertical: 9.0),
        child: Center(
          child: Text(
            title,
            style: isSelected
                ? theme.textTheme.labelMedium
                    ?.copyWith(fontSize: 15.0, color: theme.primaryColor)
                : theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
