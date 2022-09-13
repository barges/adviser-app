import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_cubit.dart';

class BrandWidget extends StatelessWidget {
  final Brand brand;
  final bool isSelected;

  const BrandWidget({Key? key, required this.brand, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = brand.isEnabled;
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: GestureDetector(
        onLongPress: () {
          if (kDebugMode) {
            context.read<LoginCubit>().emailController.text =
            'niskov.test@gmail.com';
            context.read<LoginCubit>().passwordController.text = '00000000';
          }
        },
        onTap: () {
          if (isEnabled && !isSelected) {
            context.read<LoginCubit>().setSelectedBrand(brand);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: isSelected ? Get.theme.primaryColor : Get.theme.hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(AppConstants.buttonRadius - 1),
              color: Get.theme.canvasColor,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 12.0,
                ),
                SvgPicture.asset(
                  brand.icon,
                  color: Get.isDarkMode ? Get.theme.backgroundColor : null,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    isEnabled ? brand.name : S.of(context).comingSoon,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Get.theme.primaryColor
                          : Get.textTheme.bodySmall?.color,
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
