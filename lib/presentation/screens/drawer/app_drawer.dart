import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/fortunica.dart';
import 'package:fortunica/presentation/common_widgets/brand_drawer_item/fortunica_drawer_item.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_bottom_sheet.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/widgets/bottom_section.dart';
import 'package:zodiac/presentation/common_widgets/brand_drawer_item/zodiac_drawer_item.dart';
import 'package:zodiac/zodiac.dart';

class AppDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AppDrawer({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (_) => DrawerCubit(
        globalGetIt.get<GlobalCachingManager>(),
      ),
      child: Builder(builder: (context) {
        final DrawerCubit cubit = context.read<DrawerCubit>();
        return Container(
            width: MediaQuery.of(context).size.width * 0.75,
            color: theme.canvasColor,
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
                                      style: theme.textTheme.headlineLarge,
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    Column(
                                      children: cubit.authorizedBrands
                                          .map(
                                            (e) => Column(
                                              children: [
                                                BrandItem(
                                                  scaffoldKey: scaffoldKey,
                                                  brand: e,
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
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontSize: 11.0,
                                          color: theme.iconTheme.color,
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
                                                  BrandItem(
                                                    brand: e,
                                                    scaffoldKey: scaffoldKey,
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
                          child: BottomSection(),
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

class BrandItem extends StatelessWidget {
  final BaseBrand brand;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final router = globalGetIt.get<AppRouter>();

  BrandItem({
    Key? key,
    required this.brand,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      switch (brand.brandAlias) {
        case FortunicaBrand.alias:
          return FortunicaDrawerItem(
            openLogoutDialog: (fortunicaContext, callback) =>
                showOkCancelBottomSheet(
              context: context,
              okButtonText: S.of(context).logOut,
              okOnTap: () {
                callback(fortunicaContext).then((value) {
                  router.pop(context);
                  scaffoldKey.currentState?.openEndDrawer();
                });
              },
            ),
          );
        case ZodiacBrand.alias:
          return ZodiacDrawerItem(
            openLogoutDialog: (zodiacContext, callback) =>
                showOkCancelBottomSheet(
              context: context,
              okButtonText: S.of(context).logOut,
              okOnTap: () {
                callback(zodiacContext).then((value) {
                  router.pop(context);
                  scaffoldKey.currentState?.openEndDrawer();
                });
              },
            ),
          );
        default:
          return const SizedBox.shrink();
      }
    });
  }
}
