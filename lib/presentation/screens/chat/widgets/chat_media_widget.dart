import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/media_message.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class ChatMediaWidget extends StatelessWidget {
  final MediaMessage mediaMessage;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final Stream<PlaybackDisposition>? playbackStream;
  final bool isPlaying;
  final bool isPlayingFinished;
  const ChatMediaWidget({
    Key? key,
    required this.mediaMessage,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.playbackStream,
    this.isPlaying = false,
    this.isPlayingFinished = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 40.0,
        right: 8.0,
        top: 4.0,
        bottom: 4.0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 14.0,
        ),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            PlayPauseBtn(
              isPlaying: isPlaying,
              onStartPlayPressed: onStartPlayPressed,
              onPausePlayPressed: onPausePlayPressed,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        StreamBuilder<PlaybackDisposition>(
                          stream: isPlaying && !isPlayingFinished
                              ? playbackStream
                              : null,
                          builder: (_, snapshot) {
                            final value = !isPlayingFinished && snapshot.hasData
                                ? snapshot.data!.position.inMilliseconds /
                                    snapshot.data!.duration.inMilliseconds
                                : 0.0;
                            final time = !isPlayingFinished && snapshot.hasData
                                ? snapshot.data!.position
                                    .toString()
                                    .substring(2, 7)
                                : "00:00";
                            return PlayProgress(
                              value: value,
                              time: time,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              'Card riading',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Get.theme.primaryColorLight,
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Assets.vectors.card.svg(
                              height: 20.0,
                              fit: BoxFit.fitHeight,
                              color: Get.theme.primaryColorLight,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              mediaMessage.duration.toString().substring(2, 7),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Get.theme.primaryColorLight,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayPauseBtn extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  const PlayPauseBtn({
    Key? key,
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
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: Get.theme.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: isPlaying
            ? Assets.vectors.pause.svg(
                fit: BoxFit.scaleDown,
                color: Get.theme.primaryColor,
              )
            : Assets.vectors.play.svg(
                fit: BoxFit.scaleDown,
                color: Get.theme.primaryColor,
              ),
      ),
    );
  }
}

class PlayProgress extends StatelessWidget {
  final double value;
  final String time;
  const PlayProgress({
    Key? key,
    required this.value,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48.0,
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Get.theme.backgroundColor,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 48.0,
              child: Text(
                time,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Get.theme.backgroundColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        LinearProgressIndicator(
          value: (!value.isNaN && !value.isInfinite) ? value : 0.0,
          backgroundColor: Get.theme.primaryColorLight,
          color: Get.theme.backgroundColor,
          minHeight: 2.0,
        ),
      ],
    );
  }
}
