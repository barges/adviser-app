import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_bottom_sheet.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawerCubit(getIt.get<CachingManager>()),
      child: Builder(builder: (context) {
        final DrawerCubit cubit = context.read<DrawerCubit>();
        return Container(
            width: MediaQuery.of(context).size.width * 0.75,
            color: Theme.of(context).canvasColor,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
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
                              const Divider(
                                height: 1.0,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              fontSize: 11.0,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
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
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          child: Row(
            children: [
              Builder(builder: (context) {
                final UserStatus currentStatus =
                    context.select((HomeCubit cubit) => cubit.state.userStatus);
                return Stack(alignment: Alignment.bottomRight, children: [
                  Container(
                    height: 56.0,
                    width: 56.0,
                    padding: const EdgeInsets.all(7.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      border: Border.all(
                        color: Theme.of(context).hintColor,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.buttonRadius),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        brand.icon,
                        color: Utils.isDarkMode(context)
                            ? Theme.of(context).backgroundColor
                            : null,
                      ),
                    ),
                  ),
                  isCurrent
                      ? Container(
                          height: 12.0,
                          width: 12.0,
                          decoration: BoxDecoration(
                            color: currentStatus.status
                                ?.statusColorForBadge(context),
                            shape: BoxShape.circle,
                            border: Border.all(
                                width: 2.0,
                                color: Theme.of(context).canvasColor),
                          ),
                        )
                      : const SizedBox.shrink(),
                ]);
              }),
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
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 16.0),
                    ),
                    if (brand.url.isNotEmpty && brand.isEnabled)
                      Text(
                        brand.url,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.0,
                              color: Theme.of(context).iconTheme.color,
                            ),
                      ),
                    if (!brand.isEnabled)
                      Text(
                        S.of(context).comingSoon,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 12.0,
                              color: Theme.of(context).iconTheme.color,
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
                    height: AppConstants.iconSize,
                    width: AppConstants.iconSize,
                    color: Theme.of(context).iconTheme.color,
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
       const Divider(
          height: 1.0,
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
                  onTap: cubit.openSettingsUrl),
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
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: AppConstants.iconSize,
              width: AppConstants.iconSize,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(
              width: 12.0,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
