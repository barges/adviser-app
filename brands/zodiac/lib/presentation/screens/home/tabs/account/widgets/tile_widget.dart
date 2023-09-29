import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/presentation/common_widgets/error_badge.dart';

class TileWidget extends StatelessWidget {
  final String iconSVGPath;
  final String title;
  final Widget? widget;
  final Widget? timerWidget;
  final bool? initSwitcherValue;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onTap;
  final bool isDisable;
  final bool withError;
  final bool withIconBadge;

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
    this.withError = false,
    this.withIconBadge = false,
  })  : assert(onTap != null || onChanged != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool needTimer = timerWidget != null;
    return Opacity(
      opacity: isDisable ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: () {
          if (!isDisable && onTap != null) {
            onTap!();
          }
        },
        child: Container(
          height: 44.0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Opacity(
                    opacity: needTimer ? 0.4 : 1.0,
                    child: Stack(children: [
                      SvgPicture.asset(
                        iconSVGPath,
                        height: AppConstants.iconSize,
                        width: AppConstants.iconSize,
                      ),
                      if (withIconBadge)
                        Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: Container(
                              height: 8.0,
                              width: 8.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.promotion,
                              ),
                            ))
                    ]),
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
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      if (needTimer) timerWidget!,
                    ],
                  ),
                ],
              ),
              if (initSwitcherValue != null)
                Row(
                  children: [
                    widget ?? const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 5.0,
                        right: AppConstants.horizontalScreenPadding,
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
                          activeColor: Theme.of(context).primaryColor,
                          trackColor: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
              if (onTap != null)
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget != null) const SizedBox(width: 2.0),
                      widget ?? const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.horizontalScreenPadding,
                        ),
                        child: Stack(
                          children: [
                            Assets.vectors.arrowRight.svg(
                              key: const Key('arrow_right_button'),
                              color: Theme.of(context).primaryColor,
                            ),
                            if (withError)
                              const Positioned(
                                right: 0.0,
                                child: ErrorBadge(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
