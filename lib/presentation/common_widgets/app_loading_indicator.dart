import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../themes/app_colors_dark.dart';
import '../../themes/app_colors_light.dart';
import '../../utils/utils.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Utils.isDarkMode(context)
          ? AppColorsDark.overlay
          : AppColorsLight.overlay,
      height: WidgetsBinding.instance.window.physicalSize.height,
      width: WidgetsBinding.instance.window.physicalSize.width,
      child: Center(
        child: SizedBox(
          height: 48.0,
          width: 48.0,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            colors: [
              Theme.of(context).iconTheme.color ?? Colors.grey,
            ],
          ),
        ),
      ),
    );
  }
}
