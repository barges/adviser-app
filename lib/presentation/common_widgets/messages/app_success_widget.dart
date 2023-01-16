import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/open_email_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AppSuccessWidget extends StatelessWidget {
  final String message;
  final bool needEmailButton;
  final VoidCallback onClose;

  const AppSuccessWidget({
    Key? key,
    required this.message,
    required this.onClose,
    this.needEmailButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  color: Theme.of(context).primaryColorLight,
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
                          Text(
                            message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
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
                        color: Theme.of(context).primaryColor,
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
