import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/tile_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';

class ReviewsPartWidget extends StatelessWidget {
  const ReviewsPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        color: Theme.of(context).canvasColor,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: AppConstants.horizontalScreenPadding),
        child: Column(
          children: [
            TileWidget(
              title: SZodiac.of(context).reviewsZodiac,
              iconSVGPath: Assets.zodiac.reviewsIcon.path,
              onTap: () {
                ///TODO add
              },
              widget: const _ReviewRatingWidget(),
            ),
            const Divider(
              height: 1.0,
            ),
            TileWidget(
              title: SZodiac.of(context).templatesContentZodiac,
              iconSVGPath: Assets.zodiac.couponIcon.path,
              onTap: () {},
            ),
            const Divider(
              height: 1.0,
            ),
            Builder(builder: (context) {
              final int unreadedCount = context.select(
                  (ZodiacAccountCubit cubit) =>
                      cubit.state.unreadedNotificationsCount);
              final ZodiacAccountCubit zodiacAccountCubit =
                  context.read<ZodiacAccountCubit>();
              return TileWidget(
                title: SZodiac.of(context).notificationsZodiac,
                iconSVGPath: Assets.vectors.notification.path,
                withIconBadge: unreadedCount > 0,
                widget: unreadedCount > 0
                    ? Container(
                        height: 18.0,
                        width: 18.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.promotion,
                        ),
                        child: Center(
                          child: Text(
                            unreadedCount.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: Theme.of(context).backgroundColor,
                                ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                onTap: () => zodiacAccountCubit.goToNotifications(context),
              );
            }),
            const Divider(
              height: 1.0,
            ),
            Builder(builder: (context) {
              final UserBalance userBalance = context.select(
                  (ZodiacAccountCubit cubit) => cubit.state.userBalance);
              return TileWidget(
                title: SZodiac.of(context).balanceTransactionsZodiac,
                iconSVGPath: Assets.zodiac.transactionsIcon.path,
                onTap: () {},
                widget: Text(
                  userBalance.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).shadowColor,
                      ),
                ),
              );
            }),
            const Divider(
              height: 1.0,
            ),
            TileWidget(
              title: SZodiac.of(context).servicesZodiac,
              iconSVGPath: Assets.zodiac.servicesIcon.path,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRatingWidget extends StatelessWidget {
  const _ReviewRatingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserDetails? userInfo =
        context.select((ZodiacAccountCubit cubit) => cubit.state.userInfo);
    final int? reviewsCount =
        context.select((ZodiacAccountCubit cubit) => cubit.state.reviewsCount);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBar(
          initialRating: userInfo?.averageRatingReal ?? 0,
          direction: Axis.horizontal,
          ignoreGestures: true,
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
        const SizedBox(
          width: 5.0,
        ),
        Text(
          '${reviewsCount ?? ''}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).shadowColor,
              ),
        )
      ],
    );
  }
}
