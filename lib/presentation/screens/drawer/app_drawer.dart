import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_controller.dart';

class AppDrawer extends GetView<AppDrawerController> {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                  children: controller
                                      .authorizedBrands()
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
                            height: 0.0,
                            color: Get.theme.hintColor,
                          ),
                          if (controller.unauthorizedBrands().isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12.0, 12.0, 12.0, 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    S.of(context).otherBrands.toUpperCase(),
                                    style: Get.textTheme.labelSmall?.copyWith(
                                      fontSize: 11.0,
                                      color: Get.iconColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Column(
                                    children: controller
                                        .unauthorizedBrands()
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
  }
}

class _BrandItem extends GetView<AppDrawerController> {
  final Brand brand;
  final bool isLoggedIn;

  const _BrandItem({
    Key? key,
    required this.brand,
    this.isLoggedIn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = brand == controller.currentBrand.value;
    return GestureDetector(
      onTap: isLoggedIn && !isCurrent
          ? () {
              controller.changeCurrentBrand(brand);
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
                  borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
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
                      style:
                          Get.textTheme.headlineMedium?.copyWith(fontSize: 16.0),
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
                    Get.back();
                    if (isCurrent) {
                      controller.logout(brand);
                    } else {
                      Get.toNamed(AppRoutes.login, arguments: brand);
                    }
                  },
                  child: SvgPicture.asset(
                    isCurrent ? AppIcons.moreHorizontal : AppIcons.login,
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

class _BottomSection extends GetView<AppDrawerController> {
  const _BottomSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          height: 0.0,
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
                  icon: AppIcons.bookOpen,
                  text: S.of(context).allOurBrands,
                  onTap: controller.goToAllBrands),
              const SizedBox(
                height: 16.0,
              ),
              _BottomSectionItem(
                  icon: AppIcons.settings,
                  text: S.of(context).settings,
                  onTap: controller.goToSettings),
              const SizedBox(
                height: 16.0,
              ),
              _BottomSectionItem(
                  icon: AppIcons.questionMark,
                  text: S.of(context).customerSupport,
                  onTap: controller.goToCustomerSupport),
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
      child: SizedBox(
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
