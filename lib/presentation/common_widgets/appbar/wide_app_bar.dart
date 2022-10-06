import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/change_locale_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class WideAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget bottomWidget;
  final String? iconPath;
  final bool withBrands;

  const WideAppBar({
    Key? key,
    required this.bottomWidget,
    this.iconPath,
    this.title,
    this.withBrands = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(96.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 96.0,
        elevation: 0.5,
        shadowColor: Get.theme.hintColor,
        flexibleSpace: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: context.read<HomeCubit>().openDrawer,
                      child: title != null && iconPath != null
                          ? _IconAndTitleWidget(
                              title: title!,
                              iconPath: iconPath!,
                            )
                          : Builder(builder: (context) {
                              final Brand currentBrand = context.select(
                                  (MainCubit cubit) =>
                                      cubit.state.currentBrand);
                              return _IconAndTitleWidget(
                                title: currentBrand.name,
                                iconPath: currentBrand.icon,
                                needIconColor: false,
                              );
                            }),
                    ),
                    withBrands
                        ? const _AuthorizedBrandsWidget()
                        : const ChangeLocaleButton(),
                  ],
                ),
              ),
              bottomWidget,
            ],
          ),
        ));
  }
}

class _IconAndTitleWidget extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool needIconColor;

  const _IconAndTitleWidget({
    Key? key,
    required this.title,
    required this.iconPath,
    this.needIconColor = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconButton(
              icon: iconPath,
              needColor: needIconColor,
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        Text(
          title,
          style: Get.textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class _AuthorizedBrandsWidget extends StatelessWidget {
  const _AuthorizedBrandsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Brand> brands = context.read<MainCubit>().getAuthorizedBrands();
    context.select((MainCubit cubit) => cubit.state.currentBrand);
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
