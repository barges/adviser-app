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
  final Widget? timerWidget;
  final bool? initSwitcherValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;

  const TileWidget({
    Key? key,
    required this.title,
    required this.iconSVGPath,
    this.widget,
    this.timerWidget,
    this.initSwitcherValue,
    this.onChanged,
    this.onTap,
    this.isDisable = false,
  })  : assert(onTap != null || onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool needTimer = timerWidget != null;
    return Opacity(
      opacity: isDisable ? 0.4 : 1.0,
      child: SizedBox(
        height: 44.0,
        child: Row(children: [
          Expanded(
            child: Row(
              children: [
                Opacity(
                  opacity: needTimer ? 0.4 : 1.0,
                  child: SvgPicture.asset(
                    iconSVGPath,
                  ),
                ),
                const SizedBox(width: 10.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: needTimer ? 0.4 : 1.0,
                      child: Text(
                        title,
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    if (needTimer) timerWidget!,
                  ],
                ),
              ],
            ),
          ),
          if (initSwitcherValue != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
              ),
              child: Opacity(
                opacity: needTimer ? 0.4 : 1.0,
                child: CupertinoSwitch(
                  value: !isDisable ? initSwitcherValue! : false,
                  onChanged: (bool value) {
                    if (!isDisable && !needTimer && onChanged != null) {
                      onChanged!(value);
                    }
                  },
                  activeColor: Get.theme.primaryColor,
                  trackColor: Get.theme.hintColor,
                ),
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
