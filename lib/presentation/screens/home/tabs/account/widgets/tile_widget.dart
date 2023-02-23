import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/error_badge.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

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
                          style: Theme.of(context).textTheme.bodyMedium,
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
                    activeColor: Theme.of(context).primaryColor,
                    trackColor: Theme.of(context).hintColor,
                  ),
                ),
              ),
            if (onTap != null)
              Row(
                children: [
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
              )
          ]),
        ),
      ),
    );
  }
}
