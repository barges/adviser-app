import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home_screen/cubit/main_home_screen_cubit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:fortunica/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:fortunica/presentation/common_widgets/buttons/change_locale_button.dart';
import 'package:fortunica/presentation/screens/home/home_cubit.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? bottomWidget;
  final String? iconPath;
  final bool withBrands;

  const HomeAppBar({
    Key? key,
    this.bottomWidget,
    this.iconPath,
    this.title,
    this.withBrands = false,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(
        bottomWidget != null
            ? AppConstants.appBarHeight * 2
            : AppConstants.appBarHeight,
      );

  @override
  Widget build(BuildContext context) {
    const Brand currentBrand = Brand.fortunica;

    return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.5,
        shadowColor: Theme.of(context).hintColor,
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
                      onTap: context.read<MainHomeScreenCubit>().openDrawer,
                      child: title != null && iconPath != null
                          ? _IconAndTitleWidget(
                              title: title!,
                              iconPath: iconPath!,
                            )
                          : _IconAndTitleWidget(
                              title: currentBrand.name,
                              iconPath: currentBrand.icon,
                              needIconColor: false,
                            ),
                    ),
                    withBrands
                        ? const _AuthorizedBrandsWidget()
                        : const ChangeLocaleButton(),
                  ],
                ),
              ),
              if (bottomWidget != null) bottomWidget!,
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
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class _AuthorizedBrandsWidget extends StatelessWidget {
  const _AuthorizedBrandsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brand currentBrand =
        context.select((MainCubit cubit) => cubit.state.currentBrand);
    final List<Brand> brands = Configuration.authorizedBrands(currentBrand);

    return Stack(
        textDirection: TextDirection.rtl,
        children: brands
            .mapIndexed((index, element) => _AuthorizedBrandWidget(
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
    return Builder(builder: (context) {
      final UserStatus? currentStatus =
          context.select((HomeCubit cubit) => cubit.state.userStatus);
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius)),
              child: SvgPicture.asset(brandIcon),
            ),
            Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                color: currentStatus?.status?.statusColorForBadge(context) ??
                    FortunicaUserStatus.offline.statusColorForBadge(context),
                shape: BoxShape.circle,
                border: Border.all(
                    width: 2.0, color: Theme.of(context).canvasColor),
              ),
            ),
          ],
        ),
      );
    });
  }
}
