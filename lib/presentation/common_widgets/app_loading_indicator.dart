import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
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
