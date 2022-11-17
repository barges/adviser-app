import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ChatItemBg extends StatelessWidget {
  final bool isBorder;
  final bool isTryAgain;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Widget child;
  const ChatItemBg({
    super.key,
    this.isBorder = false,
    this.isTryAgain = false,
    required this.padding,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 12.0,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              border: isBorder
                  ? Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            child: child,
          ),
          if (isTryAgain)
            const Positioned(
              right: 0.0,
              bottom: -24.0,
              child: TryAgain(),
            )
        ],
      ),
    );
  }
}

class TryAgain extends StatelessWidget {
  const TryAgain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.0,
      height: 32.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).tryAgain,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).errorColor,
                  fontSize: 12.0,
                ),
          ),
          const SizedBox(
            width: 5.33,
          ),
          Assets.vectors.refresh.svg(
            width: 13.33,
          ),
        ],
      ),
    );
  }
}
