import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/user_info/daily_coupon_info.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/daily_coupons/counter_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';

class DailyCouponsWidget extends StatelessWidget {
  final List<DailyCouponInfo> dailyCoupons;
  final bool limitReached;

  const DailyCouponsWidget({
    Key? key,
    required this.dailyCoupons,
    required this.limitReached,
  }) : super(key: key);

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
            itemBuilder: (context, columnIndex) => _DailyCouponWidget(
              dailyCoupon: dailyCoupons[columnIndex + rowIndex * 3],
              limitReached: limitReached,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12.0),
            itemCount: 3,
          ),
        ),
      ),
    );
  }
}

class _DailyCouponWidget extends StatelessWidget {
  final DailyCouponInfo dailyCoupon;
  final bool limitReached;

  const _DailyCouponWidget({
    Key? key,
    required this.dailyCoupon,
    required this.limitReached,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showCounter =
        dailyCoupon.count != null && dailyCoupon.count! > 0;

    final ZodiacAccountCubit accountCubit = context.read<ZodiacAccountCubit>();

    return Opacity(
      opacity: limitReached && !showCounter ? 0.6 : 1.0,
      child: Blur(
        blur: showCounter ? 2 : 0,
        blurColor:
            showCounter ? Utils.getOverlayColor(context) : Colors.transparent,
        colorOpacity: showCounter ? 0.5 : 0.0,
        borderRadius: BorderRadius.circular(12.0),
        overlay: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showCounter)
                    CounterWidget(
                      count: dailyCoupon.count ?? 1,
                      limitReached: limitReached,
                      couponId: dailyCoupon.couponId,
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
                child: CheckboxWidget(
                  value: showCounter,
                  onChanged: (value) {
                    if (!value) {
                      accountCubit.onDailyCouponCheckboxChanged(
                          dailyCoupon.couponId, value);
                    } else if (value && !limitReached) {
                      accountCubit.onDailyCouponCheckboxChanged(
                          dailyCoupon.couponId, value);
                    }
                  },
                ),
              ),
            )
          ],
        ),
        child: AppImageWidget(
          uri: Uri.parse(
            dailyCoupon.image ?? '',
          ),
        ),
      ),
    );
  }
}
