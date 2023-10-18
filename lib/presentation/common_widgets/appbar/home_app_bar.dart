import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_constants.dart';
import '../../../generated/assets/assets.gen.dart';
import '../../../main_cubit.dart';
import '../buttons/app_icon_button.dart';
import '../buttons/change_locale_button.dart';

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
    // TODO DELETE
    //final BaseBrand currentBrand = FortunicaBrand();

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
                      onTap: context.read<MainCubit>().openDrawer,
                      child: title != null && iconPath != null
                          ? _IconAndTitleWidget(
                              title: title!,
                              iconPath: iconPath!,
                            )
                          : _IconAndTitleWidget(
                              title: AppConstants.fortunicaName,
                              iconPath: Assets.vectors.fortunica.path,
                              needIconColor: false,
                            ),
                    ),
                    // TODO DELETE
                    /*withBrands
                        ? Builder(builder: (context) {
                            context.select(
                                (HomeCubit cubit) => cubit.state.userStatus);
                            return AuthorizedBrandsAppBarWidget();
                          })
                        : */
                    const ChangeLocaleButton(),
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
