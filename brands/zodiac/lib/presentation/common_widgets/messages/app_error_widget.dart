import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? close;

  final double? height;
  final VoidCallback? onTapUrl;

  const AppErrorWidget({
    Key? key,
    required this.errorMessage,
    this.close,
    this.height,
    this.onTapUrl,
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
      child: errorMessage.isNotEmpty
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: height,
              decoration: BoxDecoration(
                  color: Theme.of(context).errorColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(AppConstants.buttonRadius),
                    bottomRight: Radius.circular(AppConstants.buttonRadius),
                  )),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          16.0, 8.0, close == null ? 16.0 : 0.0, 8.0),
                      child: errorMessage.isHtml
                          ? HtmlWidget(
                              errorMessage,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 15.0,
                                  ),
                              customStylesBuilder: (element) {
                                if (element.toString().contains("<html a>")) {
                                  return {'color': 'white'};
                                }
                                return null;
                              },
                              onTapUrl: (_) {
                                onTapUrl?.call();
                                return true;
                              },
                            )
                          : Text(
                              errorMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 15.0,
                                  ),
                            ),
                    ),
                  ),
                  if (close != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: GestureDetector(
                        onTap: close,
                        child: Assets.vectors.close.svg(
                          color: Theme.of(context).backgroundColor,
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
