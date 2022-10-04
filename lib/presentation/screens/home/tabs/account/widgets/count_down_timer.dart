import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class CountDownTimer extends StatelessWidget {
  final int seconds;
  final VoidCallback onEnd;

  const CountDownTimer({
    required this.seconds,
    required this.onEnd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(
        duration: Duration(
          seconds: seconds,
        ),
        tween: Tween(
          begin: Duration(seconds: seconds),
          end: Duration.zero,
        ),
        onEnd: onEnd,
        builder: (BuildContext context, Duration value, Widget? child) {
          final minutes = value.inMinutes;
          final seconds = value.inSeconds % 60;
          return Text(
            '${S.of(context).willBeAvailableInAnHour}'
            ' $minutes:${seconds < 10 ? '0$seconds' : seconds}',
            textAlign: TextAlign.center,
            style: Get.textTheme.bodySmall?.copyWith(
              color: Get.theme.errorColor,
              fontSize: 12,
            ),
          );
        });
  }
}
