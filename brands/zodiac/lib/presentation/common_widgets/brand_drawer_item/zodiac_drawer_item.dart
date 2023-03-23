import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/network/websocket_manager/websocket_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_auth_repository.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/brand_drawer_item/zodiac_drawer_item_cubit.dart';
import 'package:zodiac/zodiac.dart';

class ZodiacDrawerItem extends StatelessWidget {
  final Function(BuildContext, AsyncValueSetter<BuildContext>) openLogoutDialog;

  const ZodiacDrawerItem({
    Key? key,
    required this.openLogoutDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ZodiacDrawerItemCubit(
        zodiacGetIt.get<ZodiacAuthRepository>(),
        zodiacGetIt.get<GlobalCachingManager>(),
        zodiacGetIt.get<ZodiacCachingManager>(),
        zodiacGetIt.get<WebSocketManager>(),
      ),
      child: Builder(builder: (context) {
        final ZodiacDrawerItemCubit cubit =
            context.read<ZodiacDrawerItemCubit>();
        final BaseBrand brand = ZodiacBrand();
        final bool isCurrent = brand.isCurrent;
        final bool isLoggedIn = brand.isAuth;
        final ThemeData theme = Theme.of(context);
        return GestureDetector(
          onTap: () {
            if (isCurrent) {
              globalGetIt.get<AppRouter>().pop(context);
            } else {
              cubit.changeCurrentBrand(context);
            }
          },
          child: Opacity(
            opacity: brand.isActive ? 1.0 : 0.4,
            child: Container(
              height: 64.0,
              padding: const EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
              decoration: BoxDecoration(
                color: isCurrent
                    ? theme.scaffoldBackgroundColor
                    : theme.canvasColor,
                borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              ),
              child: Row(
                children: [
                  Builder(builder: (context) {
                    // final UserStatus? currentStatus = cubit.userStatus;
                    return Stack(alignment: Alignment.bottomRight, children: [
                      Container(
                        height: 56.0,
                        width: 56.0,
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                          color: theme.canvasColor,
                          border: Border.all(
                            color: theme.hintColor,
                          ),
                          borderRadius:
                              BorderRadius.circular(AppConstants.buttonRadius),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            brand.iconPath,
                            color: Utils.isDarkMode(context)
                                ? theme.backgroundColor
                                : null,
                          ),
                        ),
                      ),
                      isLoggedIn
                          ? Container(
                              height: 12.0,
                              width: 12.0,
                              decoration: BoxDecoration(
                                // color: currentStatus?.status
                                //         ?.statusColorForBadge(context) ??
                                //     theme.shadowColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2.0, color: theme.canvasColor),
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
                          style: theme.textTheme.headlineMedium
                              ?.copyWith(fontSize: 16.0),
                        ),
                        if (brand.url.isNotEmpty && brand.isActive)
                          Text(
                            brand.url,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12.0,
                              color: theme.iconTheme.color,
                            ),
                          ),
                        if (!brand.isActive)
                          Text(
                            S.of(context).comingSoon,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12.0,
                              color: theme.iconTheme.color,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (brand.isActive && (isCurrent || !isLoggedIn))
                    GestureDetector(
                      onTap: () {
                        if (isCurrent && isLoggedIn) {
                          openLogoutDialog(context, cubit.logout);
                        } else if (!isCurrent) {
                          cubit.changeCurrentBrand(context);
                        } else {
                          globalGetIt.get<AppRouter>().pop(context);
                        }
                      },
                      child: SvgPicture.asset(
                        isCurrent && isLoggedIn
                            ? Assets.vectors.moreHorizontal.path
                            : Assets.vectors.login.path,
                        height: AppConstants.iconSize,
                        width: AppConstants.iconSize,
                        color: theme.iconTheme.color,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
