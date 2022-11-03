import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';

class ChatRecordedWidget extends StatelessWidget {
  final VoidCallback? onPhotoPressed;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onSendPressed;
  final bool isPlaying;
  final Stream<PlaybackDisposition>? playbackStream;

  const ChatRecordedWidget({
    Key? key,
    this.onPhotoPressed,
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
      padding: const EdgeInsets.fromLTRB(24.0, 6.0, 24.0, 6.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPhotoPressed,
            child: Assets.vectors.photo.svg(width: AppConstants.iconSize),
          ),
          SizedBox(
            height: 28.0,
            child: VerticalDivider(
              width: 24.0,
              color: Get.theme.dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5.0,
              right: 17.0,
            ),
            child: Assets.vectors.microphone.svg(width: AppConstants.iconSize),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Get.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              ),
              child: Row(
                children: [
                  _PlayPauseBtn(
                    isPlaying: isPlaying,
                    onStartPlayPressed: onStartPlayPressed,
                    onPausePlayPressed: onPausePlayPressed,
                  ),
                  const SizedBox(
                    width: 8.0,
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
                              return _PlayProgress(
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
                              left: 8.0,
                              right: 4.0,
                            ),
                            child: Assets.vectors.delete.svg(
                                width: AppConstants.iconSize,
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
              width: AppConstants.iconButtonSize,
            ),
          )
        ],
      ),
    );
  }
}

class _PlayPauseBtn extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  const _PlayPauseBtn({
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
        width: AppConstants.iconButtonSize,
        height: AppConstants.iconButtonSize,
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: isPlaying
            ? Assets.vectors.pause.svg(
                fit: BoxFit.none,
                color: Get.theme.backgroundColor,
              )
            : Assets.vectors.play.svg(
                fit: BoxFit.none,
                color: Get.theme.backgroundColor,
              ),
      ),
    );
  }
}

class _PlayProgress extends StatelessWidget {
  final double value;
  final String time;
  const _PlayProgress({
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
          width: 8.0,
        ),
        SizedBox(
          width: 45.0,
          child: Text(
            time,
            textAlign: TextAlign.left,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.hoverColor,
            ),
          ),
        ),
      ],
    );
  }
}
