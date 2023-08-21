import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';

class CategoryItemWidget extends StatelessWidget {
  final String? image;
  final String? icon;
  final String? name;
  final bool isSelected;

  final double borderRadius = 12.0;

  const CategoryItemWidget({
    Key? key,
    this.image,
    this.icon,
    this.name,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: [
        AppImageWidget(
          uri: Uri.parse(image ?? ''),
          height: 148.0,
          width: 148.0,
          radius: borderRadius,
        ),
        if (isSelected)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: theme.primaryColor,
                  width: 2.0,
                ),
              ),
            ),
          ),
        Positioned(
          top: 16.0,
          left: 16.0,
          child: BlurryContainer(
            height: AppConstants.iconButtonSize,
            width: AppConstants.iconButtonSize,
            color: isSelected ? theme.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(90.0),
            child: AppImageWidget(
              uri: Uri.parse(icon ?? ''),
              height: AppConstants.iconSize,
              width: AppConstants.iconSize,
              imageColor: theme.canvasColor,
              colorBlendMode: BlendMode.srcIn,
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          child: Text(
            name ?? '',
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 16.0,
              color: theme.canvasColor,
            ),
          ),
        )
      ],
    );
  }
}
