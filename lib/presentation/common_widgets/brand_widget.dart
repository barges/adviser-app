/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortunica_for_readers/generated/l10n.dart';

import '../../app_constants.dart';
import '../../infrastructure/brands/base_brand.dart';
import '../../main_cubit.dart';
import '../../utils/utils.dart';

class BrandWidget extends StatelessWidget {
  final BaseBrand brand;
  final bool isSelected;

  const BrandWidget({Key? key, required this.brand, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = brand.isActive;
    final ThemeData theme = Theme.of(context);
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: () {
          if (isEnabled && !isSelected) {
            context.read<MainCubit>().changeCurrentBrand(brand);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: isSelected ? theme.primaryColor : theme.hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.buttonRadius - 1),
              color: theme.canvasColor,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 12.0,
                ),
                SvgPicture.asset(
                  brand.iconPath,
                  color:
                      Utils.isDarkMode(context) ? theme.backgroundColor : null,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    isEnabled ? brand.name : SFortunica.of(context).comingSoon,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? theme.primaryColor
                          : theme.textTheme.bodySmall?.color,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/