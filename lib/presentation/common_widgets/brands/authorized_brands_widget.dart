import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class AuthorizedBrandsWidget extends StatelessWidget {
  const AuthorizedBrandsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Brand> brands = context.read<MainCubit>().getAuthorizedBrands();

    return Stack(
        textDirection: TextDirection.rtl,
        children: brands
            .mapIndexed((element, index) => _AuthorizedBrandWidget(
                  index: index,
                  brandIcon: element.icon,
                  isFirstBrand: index == brands.length - 1,
                ))
            .toList());
  }
}

class _AuthorizedBrandWidget extends StatelessWidget {
  final int index;
  final bool isFirstBrand;
  final String brandIcon;

  const _AuthorizedBrandWidget(
      {Key? key,
      required this.index,
      required this.isFirstBrand,
      required this.brandIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 24.0 * index),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            height: AppConstants.iconButtonSize,
            width: AppConstants.iconButtonSize,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Get.theme.scaffoldBackgroundColor,
                border: Border.all(
                    width: 2.0,
                    color: isFirstBrand
                        ? AppColors.promotion
                        : Get.theme.canvasColor),
                borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
            child: SvgPicture.asset(brandIcon),
          ),
          Container(
            height: 12.0,
            width: 12.0,
            decoration: BoxDecoration(
              color: AppColors.online,
              shape: BoxShape.circle,
              border: Border.all(width: 2.0, color: Get.theme.canvasColor),
            ),
          ),
        ],
      ),
    );
  }
}
