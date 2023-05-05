import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/presentation/common_widgets/search_widget.dart';

class PhoneCodeSearchAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ValueChanged<String> onChanged;

  const PhoneCodeSearchAppBar({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.5,
      toolbarHeight: AppConstants.appBarHeight,
      actions: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 16.0),
          child: AppIconButton(
            icon: Assets.vectors.close.path,
            onTap: () {
              context.pop();
            },
          ),
        ),
      ],
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 40.0),
          alignment: Alignment.centerLeft,
          child: SearchWidget(
            autofocus: true,
            isBorder: false,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
