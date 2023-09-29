import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

class TileMenuButton extends StatelessWidget {
  final String label;
  final String? title;
  final VoidCallback? onTap;
  final bool isError;
  final Color? color;

  const TileMenuButton({
    Key? key,
    required this.label,
    this.title,
    this.onTap,
    this.color,
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
            style: theme.textTheme.labelMedium,
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
                color: theme.canvasColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title ?? SZodiac.of(context).notSelectedZodiac,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: title != null
                                ? theme.hoverColor
                                : theme.shadowColor),
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
