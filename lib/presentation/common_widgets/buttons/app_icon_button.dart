import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app_constants.dart';

class AppIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final bool needColor;
  final Color? color;

  ///TODO: need change

  const AppIconButton({
    Key? key,
    required this.icon,
    this.onTap,
    this.color,
    this.needColor = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.iconButtonSize,
        width: AppConstants.iconButtonSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
            child: SvgPicture.asset(
          icon,
          color: color ?? (needColor ? Theme.of(context).primaryColor : null),
          height: AppConstants.iconSize,
          width: AppConstants.iconSize,
        )),
      ),
    );
  }
}
