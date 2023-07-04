import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/user_info/daily_coupon_info.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';

class DailyCouponsPartWidget extends StatelessWidget {
  const DailyCouponsPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<DailyCouponInfo>? dailyCoupons =
        context.select((ZodiacAccountCubit cubit) => cubit.state.dailyCoupons);

    if (dailyCoupons != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: theme.canvasColor,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        SZodiac.of(context).showDailyCouponsZodiac,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 17.0),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: theme.primaryColor,
                        ),
                        child: Builder(builder: (context) {
                          final int dailyCouponsLimit = context.select(
                              (ZodiacAccountCubit cubit) =>
                                  cubit.state.dailyCouponsLimit);
                          return Text(
                            '5/$dailyCouponsLimit',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 13.0,
                              color: theme.canvasColor,
                            ),
                          );
                        }),
                      ),
                      const Spacer(),
                      Builder(builder: (context) {
                        final bool dailyCouponsEnabled = context.select(
                            (ZodiacAccountCubit cubit) =>
                                cubit.state.dailyCouponsEnabled);
                        return CupertinoSwitch(
                          value: dailyCouponsEnabled,
                          onChanged: (bool value) {},
                          activeColor: Theme.of(context).primaryColor,
                          trackColor: Theme.of(context).hintColor,
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    SZodiac.of(context)
                        .theNumberOfAvailableCouponsDependsOnTheAmountOfSessionsZodiac,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.shadowColor),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
            _DailyCouponsWidget(
              dailyCoupons: dailyCoupons,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              theme.primaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 13.0,
                            horizontal: 16.0,
                          ),
                          child: Text(
                            SZodiac.of(context).saveCouponsSetZodiac,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontSize: 17.0,
                              color: theme.canvasColor,
                            ),
                          ),
                        ),
                        onPressed: () {}),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        SZodiac.of(context).dailyRenewalZodiac,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontSize: 17.0),
                      ),
                      Builder(builder: (context) {
                        final bool dailyRenewalEnabled = context.select(
                            (ZodiacAccountCubit cubit) =>
                                cubit.state.dailyRenewalEnabled);
                        return CupertinoSwitch(
                          value: dailyRenewalEnabled,
                          onChanged: (bool value) {},
                          activeColor: Theme.of(context).primaryColor,
                          trackColor: Theme.of(context).hintColor,
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    SZodiac.of(context)
                        .selectedCouponsWillBeRenewedAutomaticallyZodiac,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.shadowColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class _DailyCouponsWidget extends StatefulWidget {
  final List<DailyCouponInfo> dailyCoupons;

  const _DailyCouponsWidget({
    Key? key,
    required this.dailyCoupons,
  }) : super(key: key);

  @override
  State<_DailyCouponsWidget> createState() => _DailyCouponsWidgetState();
}

class _DailyCouponsWidgetState extends State<_DailyCouponsWidget> {
  @override
  Widget build(BuildContext context) {
    final double couponHeight = 96 /
        264 *
        (MediaQuery.of(context).size.width -
            AppConstants.horizontalScreenPadding * 2) *
        0.8;
    return SizedBox(
      height: couponHeight * 3 + 12 * 2,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.8),
        itemCount: 3,
        itemBuilder: (context, rowIndex) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, columnIndex) => DailyCouponWidget(
              dailyCoupon: widget.dailyCoupons[columnIndex + rowIndex * 3],
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemCount: 3,
          ),
        ),
      ),
    );
  }
}

class DailyCouponWidget extends StatefulWidget {
  final DailyCouponInfo dailyCoupon;

  const DailyCouponWidget({Key? key, required this.dailyCoupon})
      : super(key: key);

  @override
  State<DailyCouponWidget> createState() => _DailyCouponWidgetState();
}

class _DailyCouponWidgetState extends State<DailyCouponWidget> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.dailyCoupon.count ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return widget.dailyCoupon.count != null && widget.dailyCoupon.count! > 0
        ? Blur(
            blur: 2,
            blurColor: Utils.getOverlayColor(context),
            borderRadius: BorderRadius.circular(12.0),
            overlay: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppConstants.buttonRadius),
                          color: theme.canvasColor,
                        ),
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppIconButton(
                              icon: Assets.vectors.minus.path,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              count.toString(),
                              style: theme.textTheme.headlineMedium
                                  ?.copyWith(fontSize: 16.0),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            AppIconButton(
                              icon: Assets.vectors.plus.path,
                              color: theme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                        value: true,
                        onChanged: (value) {},
                      ),
                    ))
              ],
            ),
            child: AppImageWidget(
              uri: Uri.parse(
                widget.dailyCoupon.image ?? '',
              ),
            ),
          )
        : AppImageWidget(
            uri: Uri.parse(
              widget.dailyCoupon.image ?? '',
            ),
          );
  }
}
