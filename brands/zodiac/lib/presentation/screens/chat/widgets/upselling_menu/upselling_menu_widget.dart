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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CannedMessagesWidget(),
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
                Expanded(
                  child: _UpsellingMenuItemWidget(
                    iconPath: Assets.zodiac.vectors.narrowCouponsIcon.path,
                    type: UpsellingMenuType.coupons,
                    selectedMenuItem: selectedMenuItem,
                  ),
                ),
                Expanded(
                  child: _UpsellingMenuItemWidget(
                    iconPath: Assets.zodiac.vectors.chatsIcon.path,
                    type: UpsellingMenuType.canned,
                    selectedMenuItem: selectedMenuItem,
                  ),
                ),
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
