import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BirthTownWidget extends StatelessWidget {
  final String address;

  const BirthTownWidget({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          color: Theme.of(context).hintColor,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          '',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: Theme.of(context).shadowColor,
              ),
        ),
        const SizedBox(height: 10.0),
        _IconAndTitleWidget(
          iconPath: Assets.vectors.location.path,
          title: address,
        ),
      ]),
    );
  }
}

class _IconAndTitleWidget extends StatelessWidget {
  final String iconPath;
  final String title;

  const _IconAndTitleWidget(
      {Key? key, required this.iconPath, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconPath),
        const SizedBox(width: 4.0),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
