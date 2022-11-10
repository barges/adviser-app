import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/tile_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';

class ReviewsSettingsPartWidget extends StatelessWidget {
  const ReviewsSettingsPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccountCubit accountCubit = context.read<AccountCubit>();
    return Container(
      padding:
          const EdgeInsets.only(left: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Get.theme.canvasColor),
      child: Column(
        children: [
          TileWidget(
            title: S.of(context).reviews,
            iconSVGPath: Assets.vectors.starActive.path,
            onTap: () => Get.toNamed(AppRoutes.reviews),
            widget: Row(
              children: [
                RatingBar(
                  initialRating: 3,
                  direction: Axis.horizontal,
                  itemSize: 18,
                  allowHalfRating: true,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    full: Assets.vectors.starFilled.svg(),
                    half: Assets.vectors.starEmpty.svg(),
                    empty: Assets.vectors.starEmpty.svg(),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  onRatingUpdate: (rating) {},
                ),
                const SizedBox(width: 8.0),
                Text(
                  "999",
                  style: Get.textTheme.bodySmall
                      ?.copyWith(color: Get.theme.shadowColor),
                ),
                Text(
                  " +25",
                  style: Get.textTheme.bodySmall
                      ?.copyWith(color: AppColors.online),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          TileWidget(
            title: S.of(context).balanceTransactions,
            iconSVGPath: Assets.vectors.transactions.path,
            onTap: () {
              Get.toNamed(AppRoutes.balanceAndTransactions);
            },
            widget: Row(
              children: [
                Text(
                  "999",
                  style: Get.textTheme.bodySmall
                      ?.copyWith(color: Get.theme.shadowColor),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1.0,
          ),
          Builder(builder: (context) {
            final UserStatus currentStatus =
                context.select((HomeCubit cubit) => cubit.state.userStatus);
            return TileWidget(
              onTap: accountCubit.openSettingsUrl,
              title: S.of(context).settings,
              iconSVGPath: Assets.vectors.settings.path,
              withError: currentStatus.status == FortunicaUserStatus.legalBlock,
            );
          })
        ],
      ),
    );
  }
}
