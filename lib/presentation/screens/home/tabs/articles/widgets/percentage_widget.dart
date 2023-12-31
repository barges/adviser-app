import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
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
          color: Theme.of(context).canvasColor,
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
              backgroundColor: Theme.of(context).hintColor,
              animateFromLastPercent: true,
              center: RichText(
                text: TextSpan(
                  text: percentageValue.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(color: Theme.of(context).errorColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: '%',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Theme.of(context).errorColor)),
                  ],
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Theme.of(context).errorColor);
        }),
        const SizedBox(width: 8.0),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  S.of(context).newMandatoryArticleIsAvailable,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                  S
                      .of(context)
                      .youHaveXdaystoReadItBeforeYourAccountWillGetBlocked(
                          7.toString()),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).shadowColor,
                        fontWeight: FontWeight.w500,
                      )),
              InkWell(
                onTap: () {
                  //TODO -- take me there
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    S.of(context).takeMeThere,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
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
