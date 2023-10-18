import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class TileMenuButton extends StatelessWidget {
  final String label;
  final String title;
  final VoidCallback? onTap;
  final bool isError;
  final Color? labelColor;
  final Color? titleColor;
  final Color? backgroundColor;

  const TileMenuButton({
    Key? key,
    required this.label,
    required this.title,
    this.onTap,
    this.labelColor,
    this.titleColor,
    this.backgroundColor,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: labelColor ?? theme.hoverColor,
            ),
          ),
        ),
        const SizedBox(
          height: 4.0,
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              color: isError ? theme.errorColor : theme.hintColor,
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
              height: AppConstants.textFieldsHeight - 3,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(AppConstants.buttonRadius - 1),
                color: backgroundColor ?? theme.canvasColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: titleColor ?? theme.hoverColor,
                        ),
                      ),
                    ),
                    if (onTap != null)
                      Assets.vectors.arrowRight.svg(
                        height: AppConstants.iconSize,
                        width: AppConstants.iconSize,
                        color: theme.iconTheme.color,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
