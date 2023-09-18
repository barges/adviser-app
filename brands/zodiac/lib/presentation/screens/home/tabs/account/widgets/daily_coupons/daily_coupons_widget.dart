import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/coupons/coupon_info.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/daily_coupons/counter_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';

class DailyCouponsWidget extends StatelessWidget {
  final List<CouponInfo> dailyCoupons;
  final bool limitReached;

  const DailyCouponsWidget({
    Key? key,
    required this.dailyCoupons,
    required this.limitReached,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const viewportFraction = 0.8;
    const spacing = 12.0;
    final couponHeight = 96 /
        264 *
        (MediaQuery.of(context).size.width -
            AppConstants.horizontalScreenPadding * 2) *
        viewportFraction;
    return SizedBox(
      height: couponHeight * 3 + spacing * 2,
      child: PageView.builder(
        controller: PageController(viewportFraction: viewportFraction),
        itemCount: 3,
        padEnds: false,
        itemBuilder: (context, rowIndex) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: spacing / 2),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, columnIndex) => _DailyCouponWidget(
              dailyCoupon: dailyCoupons[columnIndex + rowIndex * 3],
              limitReached: limitReached,
              height: couponHeight,
            ),
            separatorBuilder: (context, index) =>
                const SizedBox(height: spacing),
            itemCount: 3,
          ),
        ),
      ),
    );
  }
}

class _DailyCouponWidget extends StatelessWidget {
  final CouponInfo dailyCoupon;
  final bool limitReached;
  final double height;

  const _DailyCouponWidget({
    Key? key,
    required this.dailyCoupon,
    required this.limitReached,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showCounter =
        dailyCoupon.count != null && dailyCoupon.count! > 0;

    final ZodiacAccountCubit accountCubit = context.read<ZodiacAccountCubit>();

    return Opacity(
      opacity: limitReached && !showCounter ? 0.6 : 1.0,
      child: ClipRRect(
        child: Stack(
          children: [
            AppImageWidget(
              uri: Uri.parse(
                dailyCoupon.image ?? '',
              ),
              height: height,
              imageColor: showCounter ? Utils.getOverlayColor(context) : null,
              colorBlendMode: BlendMode.srcATop,
              fit: BoxFit.fill,
            ),
            if (showCounter)
              const Positioned.fill(
                child: _BlurWidget(),
              ),
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
      ),
    );
  }
}

class _BlurWidget extends StatelessWidget {
  const _BlurWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Container(
        color: Colors.transparent,
      ),
    );
  }
}
