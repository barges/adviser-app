import 'dart:math';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class PerformanceMOMAWidget extends StatelessWidget {
  const PerformanceMOMAWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Blur(
      blur: 2.0,
      overlay: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(S.of(context).comingSoon,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          Text(S.of(context).performanceOverviewAnalytics,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).shadowColor))
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _PerformanceMOMAPercentageIndicatorWidget(
                    percentageValue: 50),
                const SizedBox(width: 18.0),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(S.of(context).customers,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          AppIconButton(icon: Assets.vectors.arrowRight.path)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0, bottom: 8.0),
                        child: Text(
                          S
                              .of(context)
                              .customersComeBackToYouAfterBuyingFirstSessionPlatform,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).shadowColor,
                                  ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                _PerformanceMOMAInfoWidget(
                    increaseValue: 2,
                    totalValue: 5,
                    rectangleColor: Theme.of(context).primaryColor,
                    infoTitle: S.of(context).newUsers),
                const SizedBox(width: 8.0),
                _PerformanceMOMAInfoWidget(
                    increaseValue: 2,
                    totalValue: 5,
                    rectangleColor:
                        Theme.of(context).primaryColor.withOpacity(.4),
                    infoTitle: S.of(context).loyalUsers),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _PerformanceMOMAInfoWidget extends StatelessWidget {
  final String infoTitle;
  final Color rectangleColor;
  final int totalValue;
  final int increaseValue;

  const _PerformanceMOMAInfoWidget(
      {Key? key,
      required this.increaseValue,
      required this.infoTitle,
      required this.rectangleColor,
      required this.totalValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12.0, 16.0, 13.0, 32.0),
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Theme.of(context).hintColor),
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                height: 16.0,
                width: 16.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.0),
                    color: rectangleColor),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  totalValue.toString(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Text(
                '+$increaseValue',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).errorColor),
              ),
              Assets.vectors.upRating.svg(
                color: Theme.of(context).errorColor,
                width: 14.0,
              )
            ]),
            const SizedBox(height: 4.0),
            Text(
              infoTitle,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).shadowColor),
            )
          ],
        ),
        //child: ,
      ),
    );
  }
}

class _PerformanceMOMAPercentageIndicatorWidget extends StatelessWidget {
  final double percentageValue;

  const _PerformanceMOMAPercentageIndicatorWidget(
      {Key? key, required this.percentageValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: percentageValue),
          duration: const Duration(seconds: 1),
          child: Center(
              child: Stack(
            children: [
              Assets.vectors.userPerformance.userPerformance.svg(),
              Assets.vectors.userPerformance.starBorder
                  .svg(color: Theme.of(context).canvasColor),
              Assets.vectors.userPerformance.star.svg(),
            ],
          )),
          builder: (BuildContext context, double size, Widget? child) {
            return Stack(
              children: [
                CustomPaint(
                  painter: _ArcPainter(size, context),
                ),
                child ?? const SizedBox()
              ],
            );
          }),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double percentageValue;
  final BuildContext context;

  _ArcPainter(this.percentageValue, this.context);

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = const Rect.fromLTWH(0.0, 0.0, 80.0, 80.0);

    canvas.drawArc(
        rect,
        0.0,
        2 * pi,
        false,
        Paint()
          ..color = Theme.of(context).primaryColor.withOpacity(0.4)
          ..strokeWidth = 12.0
          ..style = PaintingStyle.stroke);

    canvas.drawArc(
        rect,
        2.2,
        calculatePercentageCircle(percentageValue),
        false,
        Paint()
          ..color = Theme.of(context).primaryColor
          ..strokeWidth = 16.0
          ..style = PaintingStyle.stroke);
  }

  static const double constantValue = pi / 50;

  double calculatePercentageCircle(double value) => constantValue * value;
}
