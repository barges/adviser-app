import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/articles/articles_cubit.dart';

class PercentageWidget extends StatelessWidget {
  const PercentageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0, horizontal: AppConstants.horizontalScreenPadding),
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
          color: Get.theme.canvasColor,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppConstants.buttonRadius),
              bottomRight: Radius.circular(AppConstants.buttonRadius))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Builder(builder: (context) {
          final int percentageValue = context
              .select((ArticlesCubit cubit) => cubit.state.percentageValue);
          return CircularPercentIndicator(
              radius: 24.0,
              lineWidth: 5.0,
              animation: true,
              animationDuration: 3000,
              percent: percentageValue / 100,
              backgroundColor: Get.theme.hintColor,
              animateFromLastPercent: true,

              center: RichText(
                text: TextSpan(
                  text: percentageValue.toString(),
                  style: Get.textTheme.displayLarge
                      ?.copyWith(color: Get.theme.errorColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: '%',
                        style: Get.textTheme.labelSmall
                            ?.copyWith(color: Get.theme.errorColor)),
                  ],
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Get.theme.errorColor);
        }),
        const SizedBox(width: 8.0),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'New mandatory article is available!',
                  style: Get.textTheme.labelMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'You have',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.shadowColor,
                    fontWeight: FontWeight.w500,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' 7 days ',
                        style: Get.textTheme.bodySmall?.copyWith(
                            color: Get.theme.errorColor,
                            fontWeight: FontWeight.w500)),
                    TextSpan(
                        text:
                            'to read it before your account will get blocked!',
                        style: Get.textTheme.bodySmall?.copyWith(
                            color: Get.theme.shadowColor,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  //TODO -- take me there
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Take me there',
                    style: Get.textTheme.labelMedium?.copyWith(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline),
                  ),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
