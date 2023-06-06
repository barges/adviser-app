import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? actionOnClick;
  final VoidCallback? backOnClick;

  const SimpleAppBar({
    Key? key,
    required this.title,
    this.actionOnClick,
    this.backOnClick,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isOnline = context
        .select((MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
      elevation: 1.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppIconButton(
              icon: Assets.vectors.arrowLeft.path,
              onTap: backOnClick ?? () => context.popRoute()),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 17.0,
                ),
          ),
          if (actionOnClick != null)
            Opacity(
              opacity: isOnline ? 1.0 : 0.4,
              child: AppIconButton(
                icon: Assets.vectors.check.path,
                onTap: isOnline ? actionOnClick : null,
              ),
            )
          else
            const SizedBox(
              width: AppConstants.iconButtonSize,
            )
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
