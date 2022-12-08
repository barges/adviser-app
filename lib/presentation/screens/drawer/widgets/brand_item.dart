import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_bottom_sheet.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/drawer_cubit.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class BrandItem extends StatelessWidget {
  final Brand brand;
  final bool isLoggedIn;

  const BrandItem({
    Key? key,
    required this.brand,
    this.isLoggedIn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerCubit cubit = context.read<DrawerCubit>();
    final Brand currentBrand = context.read<MainCubit>().state.currentBrand;
    final bool isCurrent = brand == currentBrand;
    final ThemeData theme = Theme.of(context);
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
            color:
                isCurrent ? theme.scaffoldBackgroundColor : theme.canvasColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          child: Row(
            children: [
              Builder(builder: (context) {
                final UserStatus? currentStatus = cubit.userStatus;
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
                        brand.icon,
                        color: Utils.isDarkMode(context)
                            ? theme.backgroundColor
                            : null,
                      ),
                    ),
                  ),
                  isCurrent
                      ? Container(
                          height: 12.0,
                          width: 12.0,
                          decoration: BoxDecoration(
                            color: currentStatus?.status
                                    ?.statusColorForBadge(context) ??
                                theme.shadowColor,
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
                    if (brand.url.isNotEmpty && brand.isEnabled)
                      Text(
                        brand.url,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.0,
                          color: theme.iconTheme.color,
                        ),
                      ),
                    if (!brand.isEnabled)
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
                    color: theme.iconTheme.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
