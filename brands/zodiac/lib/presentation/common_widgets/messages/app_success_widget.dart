import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/presentation/common_widgets/buttons/open_email_button.dart';

class AppSuccessWidget extends StatelessWidget {
  final String message;
  final String? title;
  final bool needEmailButton;
  final VoidCallback onClose;

  const AppSuccessWidget({
    Key? key,
    required this.message,
    required this.onClose,
    this.title,
    this.needEmailButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1,
          child: child,
        );
      },
      child: message.isNotEmpty
          ? Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: theme.primaryColorLight,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppConstants.buttonRadius),
                    bottomRight: Radius.circular(AppConstants.buttonRadius),
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontSize: 16.0,
                                color: theme.primaryColor,
                              ),
                            ),
                          Text(
                            message,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.primaryColor,
                            ),
                          ),
                          if (needEmailButton)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: OpenEmailButton(),
                            )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 8.0),
                    child: GestureDetector(
                      onTap: onClose,
                      child: Assets.vectors.close.svg(
                        color: theme.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
