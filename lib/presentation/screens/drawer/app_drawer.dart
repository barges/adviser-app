import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/cache_manager.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_bottom_sheet.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawerCubit(Get.find<CacheManager>()),
      child: Builder(builder: (context) {
        final DrawerCubit cubit = context.read<DrawerCubit>();
        return Container(
            width: Get.width * 0.75,
            color: Get.theme.canvasColor,
            child: SafeArea(
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: false,
                    child: Column(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12.0, 12.0, 12.0, 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).workspaces,
                                      style: Get.textTheme.headlineLarge,
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Column(
                                      children: cubit.authorizedBrands
                                          .map(
                                            (e) => Column(
                                              children: [
                                                _BrandItem(
                                                  brand: e,
                                                  isLoggedIn: true,
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1.0,
                                color: Get.theme.hintColor,
                              ),
                              if (cubit.unauthorizedBrands.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 12.0, 12.0, 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        S.of(context).otherBrands.toUpperCase(),
                                        style:
                                            Get.textTheme.labelSmall?.copyWith(
                                          fontSize: 11.0,
                                          color: Get.iconColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      Column(
                                        children: cubit.unauthorizedBrands
                                            .map(
                                              (e) => Column(
                                                children: [
                                                  _BrandItem(
                                                    brand: e,
                                                  ),
                                                  const SizedBox(
                                                    height: 8.0,
                                                  ),
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      )
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: _BottomSection(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}

class _BrandItem extends StatelessWidget {
  final Brand brand;
  final bool isLoggedIn;

  const _BrandItem({
    Key? key,
    required this.brand,
    this.isLoggedIn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerCubit cubit = context.read<DrawerCubit>();
    final Brand currentBrand = context.read<MainCubit>().state.currentBrand;
    final bool isCurrent = brand == currentBrand;
    return GestureDetector(
      onTap: isLoggedIn && !isCurrent
          ? () {
              cubit.changeCurrentBrand(brand);
            }
          : null,
      child: Opacity(
        opacity: brand.isEnabled ? 1.0 : 0.4,
        child: Container(
          height: 64.0,
          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
          decoration: BoxDecoration(
            color: isCurrent
                ? Get.theme.scaffoldBackgroundColor
                : Get.theme.canvasColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          child: Row(
            children: [
              Container(
                height: 56.0,
                width: 56.0,
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  color: Get.theme.canvasColor,
                  border: Border.all(
                    color: Get.theme.hintColor,
                  ),
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    brand.icon,
                    color: Get.isDarkMode ? Get.theme.backgroundColor : null,
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      brand.name,
                      style: Get.textTheme.headlineMedium
                          ?.copyWith(fontSize: 16.0),
                    ),
                    if (brand.url.isNotEmpty && brand.isEnabled)
                      Text(
                        brand.url,
                        style: Get.textTheme.bodySmall?.copyWith(
                          fontSize: 12.0,
                          color: Get.iconColor,
                        ),
                      ),
                    if (!brand.isEnabled)
                      Text(
                        S.of(context).comingSoon,
                        style: Get.textTheme.bodySmall?.copyWith(
                          fontSize: 12.0,
                          color: Get.iconColor,
                        ),
                      ),
                  ],
                ),
              ),
              if (brand.isEnabled && (isCurrent || !isLoggedIn))
                GestureDetector(
                  onTap: () {
                    if (isCurrent) {
                      showOkCancelBottomSheet(
                        context: context,
                        okButtonText: S.of(context).logOut,
                        okOnTap: () {
                          cubit.logout(brand);
                        },
                      );
                    } else {
                      Get.back();
                      Get.toNamed(AppRoutes.login, arguments: brand);
                    }
                  },
                  child: SvgPicture.asset(
                    isCurrent
                        ? Assets.vectors.moreHorizontal.path
                        : Assets.vectors.login.path,
                    height: AppConstants.iconsSize,
                    width: AppConstants.iconsSize,
                    color: Get.iconColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerCubit cubit = context.read<DrawerCubit>();
    return Column(
      children: [
        Divider(
          height: 1.0,
          color: Get.theme.hintColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 24.0,
          ),
          child: Column(
            children: [
              _BottomSectionItem(
                icon: Assets.vectors.bookOpen.path,
                text: S.of(context).allOurBrands,
                onTap: cubit.goToAllBrands,
              ),
              const SizedBox(
                height: 16.0,
              ),
              _BottomSectionItem(
                  icon: Assets.vectors.settings.path,
                  text: S.of(context).settings,
                  onTap: cubit.goToSettings),
              const SizedBox(
                height: 16.0,
              ),
              _BottomSectionItem(
                icon: Assets.vectors.questionMark.path,
                text: S.of(context).customerSupport,
                onTap: cubit.goToCustomerSupport,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomSectionItem extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;

  const _BottomSectionItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
        onTap();
      },
      child: Container(
        width: Get.width,
        color: Colors.transparent,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: AppConstants.iconsSize,
              width: AppConstants.iconsSize,
              color: Get.iconColor,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Text(
              text,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
