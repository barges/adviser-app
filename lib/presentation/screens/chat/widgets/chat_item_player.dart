import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class ChatItemPlayer extends StatelessWidget {
  final Duration duration;
  final Color colorIcon;
  final Color colorBtn;
  final Color textColor;
  final Color colorProgressIndicator;
  final Color bgColorProgressIndicator;
  final bool isPlaying;
  final bool isPlayingFinished;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final Stream<PlaybackDisposition>? playbackStream;
  const ChatItemPlayer({
    super.key,
    required this.duration,
    required this.colorIcon,
    required this.colorBtn,
    required this.textColor,
    required this.colorProgressIndicator,
    required this.bgColorProgressIndicator,
    this.isPlaying = false,
    this.isPlayingFinished = false,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.playbackStream,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PlayPauseBtn(
          isPlaying: isPlaying,
          color: colorBtn,
          colorIcon: colorIcon,
          onStartPlayPressed: onStartPlayPressed,
          onPausePlayPressed: onPausePlayPressed,
        ),
        const SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: StreamBuilder<PlaybackDisposition>(
            stream: isPlaying && !isPlayingFinished ? playbackStream : null,
            builder: (_, snapshot) {
              final value = !isPlayingFinished && snapshot.hasData
                  ? snapshot.data!.position.inMilliseconds /
                      snapshot.data!.duration.inMilliseconds
                  : 0.0;
              final time = !isPlayingFinished && snapshot.hasData
                  ? snapshot.data!.position.toString().substring(2, 7)
                  : "00:00";
              return _PlayProgress(
                value: value,
                time: time,
                duration: duration,
                textColor: textColor,
                backgroundColor: bgColorProgressIndicator,
                color: colorProgressIndicator,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlayPauseBtn extends StatelessWidget {
  final Color colorIcon;
  final Color color;
  final bool isPlaying;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  const _PlayPauseBtn({
    Key? key,
    required this.colorIcon,
    required this.color,
    this.isPlaying = false,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        (isPlaying ? onPausePlayPressed : onStartPlayPressed)?.call();
      },
      child: Container(
        width: 34.0,
        height: 34.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: isPlaying
            ? Assets.vectors.pause.svg(
                fit: BoxFit.none,
                color: colorIcon,
              )
            : Assets.vectors.play.svg(
                fit: BoxFit.none,
                color: colorIcon,
              ),
      ),
    );
  }
}

class _PlayProgress extends StatelessWidget {
  final double value;
  final String time;
  final Duration duration;
  final Color textColor;
  final Color color;
  final Color backgroundColor;
  const _PlayProgress({
    Key? key,
    required this.value,
    required this.time,
    required this.duration,
    required this.textColor,
    required this.color,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              time,
              style: Get.textTheme.bodySmall?.copyWith(
                color: textColor,
                fontSize: 12.0,
              ),
            ),
            const Spacer(),
            Text(
              duration.toString().substring(2, 7),
              style: Get.textTheme.bodySmall?.copyWith(
                color: textColor,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        LinearProgressIndicator(
          value: (!value.isNaN && !value.isInfinite) ? value : 0.0,
          backgroundColor: backgroundColor,
          color: color,
          minHeight: 2.0,
        ),
        const SizedBox(
          height: 24.0,
        )
      ],
    );
  }
}
