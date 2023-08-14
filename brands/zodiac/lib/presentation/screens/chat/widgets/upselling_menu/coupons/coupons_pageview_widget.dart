import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/coupons/coupon_info.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/coupons/coupons_cubit.dart';

class CouponsPageViewWidget extends StatefulWidget {
  final List<CouponInfo> coupons;

  const CouponsPageViewWidget({
    Key? key,
    required this.coupons,
  }) : super(key: key);

  @override
  State<CouponsPageViewWidget> createState() => _CouponsPageViewWidgetState();
}

class _CouponsPageViewWidgetState extends State<CouponsPageViewWidget> {
  static const double viewportFraction = 0.8;
  static const double horizontalPadding = 6.0;

  final PageController _pageController =
      PageController(initialPage: 1, viewportFraction: viewportFraction);

  @override
  Widget build(BuildContext context) {
    final double height = 96 /
        264 *
        (MediaQuery.of(context).size.width - (horizontalPadding * 2)) *
        viewportFraction;

    final CouponsCubit couponsCubit = context.read<CouponsCubit>();

    final int selectedCouponIndex =
        context.select((CouponsCubit cubit) => cubit.state.selectedCouponIndex);

    return SizedBox(
      height: height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.coupons.length,
        onPageChanged: couponsCubit.onPageChanged,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Opacity(
            opacity: selectedCouponIndex == index ? 1.0 : 0.6,
            child: AppImageWidget(
              uri: Uri.parse(
                widget.coupons[index].image ?? '',
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
