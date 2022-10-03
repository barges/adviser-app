import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class TileWidget extends StatelessWidget {
  final bool isDisable;
  final String iconSVGPath;
  final String title;
  final Widget? widget;
  final bool? initSwitcherValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  const TileWidget({
    Key? key,
    required this.title,
    required this.iconSVGPath,
    this.widget,
    this.initSwitcherValue,
    this.onChanged,
    this.onTap,
    this.isDisable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisable ? 0.4 : 1.0,
      child: Container(
        height: 44.0,
        padding: EdgeInsets.symmetric(vertical: onChanged != null ? 6.0 : 10.0),
        child: Row(children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(
                  iconSVGPath,
                ),
                const SizedBox(width: 10.0),
                Text(
                  title,
                  style: Get.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (initSwitcherValue != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
              ),
              child: CupertinoSwitch(
                value: !isDisable ? initSwitcherValue! : false,
                onChanged: (bool value) {
                  if (!isDisable && onChanged != null) {
                    onChanged!(value);
                  }
                },
                activeColor: Get.theme.primaryColor,
                trackColor: Get.theme.hintColor,
              ),
            ),
          if (onTap != null)
            Row(
              children: [
                widget ?? const SizedBox(),
                GestureDetector(
                  onTap: () {
                    if (!isDisable && onTap != null) {
                      onTap!();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding,
                    ),
                    child: Assets.vectors.arrowRight.svg(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                ),
              ],
            )
        ]),
      ),
    );
  }
}
