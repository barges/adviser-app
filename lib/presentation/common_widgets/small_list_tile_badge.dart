import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class SmallListTileBadge extends StatelessWidget {
  const SmallListTileBadge({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double diameter = 8.0;
    return Container(
      alignment: Alignment.center,
      height: diameter,
      width: diameter,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.promotion,
      ),
    );
  }
}
