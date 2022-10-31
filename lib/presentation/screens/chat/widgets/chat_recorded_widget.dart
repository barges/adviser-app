import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class ChatRecordedWidget extends StatelessWidget {
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onSendPressed;
  final bool isPlaying;
  final Stream<PlaybackDisposition>? playbackStream;

  const ChatRecordedWidget({
    Key? key,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.onDeletePressed,
    this.onSendPressed,
    this.playbackStream,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        left: 25.0,
        right: 25.0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: null, //onPhotoPressed,
            child: Assets.vectors.photo.svg(),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 13.0,
            ),
            child: SizedBox(
              height: 37.0,
              child: VerticalDivider(
                thickness: 1,
                color: Get.theme.dividerColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Get.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.0),
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
                          child: StreamBuilder<PlaybackDisposition>(
                            stream: playbackStream,
                            builder: (_, snapshot) {
                              final value =
                                  playbackStream != null && snapshot.hasData
                                      ? snapshot.data!.position.inMilliseconds /
                                          snapshot.data!.duration.inMilliseconds
                                      : 0.0;
                              final time =
                                  playbackStream != null && snapshot.hasData
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
                        ),
                        GestureDetector(
                          onTap: onDeletePressed,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 2.0,
                              right: 8.0,
                            ),
                            child: Assets.vectors.delete.svg(
                                fit: BoxFit.scaleDown,
                                color: Get.theme.shadowColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          GestureDetector(
            onTap: onSendPressed,
            child: Assets.images.send.image(
              fit: BoxFit.fitWidth,
              width: 35.0,
            ),
          )
        ],
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
        width: 34.0,
        height: 34.0,
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: isPlaying
            ? Assets.vectors.pause.svg(
                fit: BoxFit.scaleDown,
                color: Get.theme.backgroundColor,
              )
            : Assets.vectors.play.svg(
                fit: BoxFit.scaleDown,
                color: Get.theme.backgroundColor,
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
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Get.theme.canvasColor,
            color: Get.theme.primaryColor,
            minHeight: 2.0,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        SizedBox(
          width: 51.0,
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
