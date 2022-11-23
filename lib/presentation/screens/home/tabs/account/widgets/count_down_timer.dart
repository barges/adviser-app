import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class CountDownTimer extends StatelessWidget {
  final int milliseconds;
  final VoidCallback onEnd;

  const CountDownTimer({
    required this.milliseconds,
    required this.onEnd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(
        duration: Duration(
          milliseconds: milliseconds,
        ),
        tween: Tween(
          begin: Duration(milliseconds: milliseconds),
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).errorColor,
                  fontSize: 12.0,
                ),
          );
        });
  }
}
