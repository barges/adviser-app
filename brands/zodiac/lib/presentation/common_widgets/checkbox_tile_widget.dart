import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class CheckboxTileWidget extends StatelessWidget {
  final bool isMultiselect;
  final bool isSelected;
  final String title;
  final VoidCallback onTap;
  final bool isLanguage;

  const CheckboxTileWidget({
    Key? key,
    required this.isMultiselect,
    required this.isSelected,
    required this.title,
    required this.onTap,
    this.isLanguage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        color: theme.canvasColor,
        height: 22.0,
        child: Row(
          children: [
            isMultiselect
                ? Container(
                    height: 22.0,
                    width: 22.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: isSelected
                            ? theme.primaryColor
                            : theme.scaffoldBackgroundColor,
                        border: isSelected
                            ? null
                            : Border.all(
                                color: theme.shadowColor,
                                width: 1.5,
                              )),
                    child: isSelected
                        ? Assets.vectors.check.svg(
                            color: theme.backgroundColor,
                            height: 22.0,
                            width: 22.0,
                          )
                        : const SizedBox.shrink(),
                  )
                : Container(
                    height: 22.0,
                    width: 22.0,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.scaffoldBackgroundColor,
                      border: Border.all(
                        color:
                            isSelected ? theme.primaryColor : theme.shadowColor,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.primaryColor,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: isLanguage
                    ? isSelected
                        ? TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: theme.hoverColor,
                          )
                        : TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: theme.hoverColor,
                          )
                    : isSelected
                        ? theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          )
                        : theme.textTheme.bodySmall?.copyWith(
                            fontSize: 16.0,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
