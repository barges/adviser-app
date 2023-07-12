import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/canned_messages/canned_messages_widget.dart';

enum UpsellingMenuType {
  coupons,
  canned,
  services;
}

class UpsellingMenuWidget extends StatelessWidget {
  const UpsellingMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final UpsellingMenuType? selectedMenuItem = context
        .select((ChatCubit cubit) => cubit.state.selectedUpsellingMenuItem);
    final List<UpsellingMenuType> enabledMenuItems =
        context.select((ChatCubit cubit) => cubit.state.enabledMenuItems);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => SizeTransition(
                  sizeFactor: animation,
                  child: child,
                ),
            child: _upsellingWidget(context, selectedMenuItem)),
        Container(
            height: 42.0,
            decoration: BoxDecoration(
                color: theme.canvasColor,
                border: Border(top: BorderSide(color: theme.hintColor))),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding,
              vertical: 4.0,
            ),
            child: Row(
              children: [
                if (enabledMenuItems.contains(UpsellingMenuType.coupons))
                  Expanded(
                    child: _UpsellingMenuItemWidget(
                      iconPath: Assets.zodiac.vectors.narrowCouponsIcon.path,
                      type: UpsellingMenuType.coupons,
                      selectedMenuItem: selectedMenuItem,
                    ),
                  ),
                if (enabledMenuItems.contains(UpsellingMenuType.canned))
                  Expanded(
                    child: _UpsellingMenuItemWidget(
                      iconPath: Assets.zodiac.vectors.chatsIcon.path,
                      type: UpsellingMenuType.canned,
                      selectedMenuItem: selectedMenuItem,
                    ),
                  ),
                if (enabledMenuItems.contains(UpsellingMenuType.services))
                  Expanded(
                    child: _UpsellingMenuItemWidget(
                      iconPath: Assets.zodiac.vectors.narrowServicesIcon.path,
                      type: UpsellingMenuType.services,
                      selectedMenuItem: selectedMenuItem,
                    ),
                  ),
              ],
            )),
      ],
    );
  }

  Widget _upsellingWidget(
      BuildContext context, UpsellingMenuType? selectedMenuItem) {
    switch (selectedMenuItem) {
      case UpsellingMenuType.canned:
        return const CannedMessagesWidget();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _UpsellingMenuItemWidget extends StatelessWidget {
  final String iconPath;
  final UpsellingMenuType type;
  final UpsellingMenuType? selectedMenuItem;
  const _UpsellingMenuItemWidget({
    Key? key,
    required this.iconPath,
    required this.type,
    this.selectedMenuItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final bool isSelected = type == selectedMenuItem;

    return GestureDetector(
      onTap: () => chatCubit.selectUpsellingMenuItem(type),
      child: Container(
        decoration: BoxDecoration(
            color: isSelected ? theme.primaryColorLight : null,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            height: AppConstants.iconSize,
            width: AppConstants.iconSize,
            colorFilter: ColorFilter.mode(
              isSelected ? theme.primaryColor : theme.shadowColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
