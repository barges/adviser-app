import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class TimerWidget extends StatelessWidget {
  final int secondsForTimer;

  const TimerWidget({
    required this.secondsForTimer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = secondsForTimer ~/ 60;
    final seconds = secondsForTimer % 60;
    return Text(
      '${S.of(context).willBeAvailableIn}'
      ' $minutes:${seconds < 10 ? '0$seconds' : seconds}',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).errorColor,
            fontSize: 12.0,
          ),
    );
  }
}
