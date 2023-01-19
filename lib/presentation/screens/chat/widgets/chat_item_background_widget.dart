import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ChatItemBackgroundWidget extends StatelessWidget {
  final bool isBorder;
  final bool isTryAgain;
  final EdgeInsets padding;
  final Color color;
  final Widget child;
  final VoidCallback? onPressedTryAgain;
  final VoidCallback? onPressedCancelSending;
  const ChatItemBackgroundWidget({
    super.key,
    this.isBorder = false,
    this.isTryAgain = false,
    this.onPressedTryAgain,
    this.onPressedCancelSending,
    required this.padding,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: isTryAgain
            ? padding.copyWith(bottom: padding.bottom + 8.0)
            : padding,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: isTryAgain ? 24.0 : 0),
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                border: isBorder
                    ? Border.all(
                        width: 1.0,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
              ),
              child: child,
            ),
            if (isTryAgain)
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onPressedTryAgain,
                  child: const _TryAgain(),
                ),
              ),
            if (isTryAgain)
              Positioned(
                right: 94.0,
                bottom: 0.0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onPressedCancelSending,
                  child: const _CancelSending(),
                ),
              ),
          ],
        ));
  }
}

class _TryAgain extends StatelessWidget {
  const _TryAgain({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).tryAgain,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12.0,
                  ),
            ),
            const SizedBox(
              width: 4.0,
            ),
            Assets.vectors.refresh.svg(
              width: 16.0,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelSending extends StatelessWidget {
  const _CancelSending({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).cancelSending,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).errorColor,
                    fontSize: 12.0,
                  ),
            ),
            const SizedBox(
              width: 4.0,
            ),
            Assets.vectors.cancel.svg(
              width: 16.0,
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
