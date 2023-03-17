import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
      ),
      child: Column(
        children: [
          Utils.isDarkMode(context)
              ? Assets.images.logos.noConnectionLogoDark.image(
                  height: AppConstants.logoSize,
                  width: AppConstants.logoSize,
                )
              : Assets.images.logos.noConnectionLogo.image(
                  height: AppConstants.logoSize,
                  width: AppConstants.logoSize,
                ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            'No internet connection',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            'Uh-oh. It looks like you\'ve lost your connection. Please try again.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).shadowColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
