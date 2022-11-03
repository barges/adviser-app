import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/chats/media_message.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ChatMediaWidget extends StatelessWidget {
  final MediaMessage mediaMessage;
  final SessionsTypes sessionsType;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final Stream<PlaybackDisposition>? playbackStream;
  final bool isPlaying;
  final bool isPlayingFinished;
  const ChatMediaWidget({
    Key? key,
    required this.mediaMessage,
    required this.sessionsType,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.playbackStream,
    this.isPlaying = false,
    this.isPlayingFinished = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(47.0, 4.0, 12.0, 4.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12.0,
        ),
        decoration: BoxDecoration(
          color: Get.theme.primaryColor,
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
              width: 12.0,
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
                            return _PlayProgress(
                              value: value,
                              time: time,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 9.0,
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              sessionsType.sessionName,
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Get.theme.primaryColorLight,
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(
                              width: 6.5,
                            ),
                            SvgPicture.asset(
                              sessionsType.iconPath,
                              width: 16.0,
                              height: 16.0,
                              color: Get.theme.primaryColorLight,
                            ),
                            const SizedBox(
                              width: 10.55,
                            ),
                            Text(
                              mediaMessage.duration.toString().substring(2, 7),
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Get.theme.primaryColorLight,
                                fontSize: 12.0,
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
        width: 34.0,
        height: 34.0,
        decoration: BoxDecoration(
          color: Get.theme.backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: isPlaying
            ? Assets.vectors.pause.svg(
                fit: BoxFit.none,
                color: Get.theme.primaryColor,
              )
            : Assets.vectors.play.svg(
                fit: BoxFit.none,
                color: Get.theme.primaryColor,
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Get.theme.backgroundColor,
                fontSize: 12.0,
              ),
            ),
            const Spacer(),
            Text(
              time,
              style: Get.textTheme.bodySmall?.copyWith(
                color: Get.theme.backgroundColor,
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
          backgroundColor: Get.theme.primaryColorLight,
          color: Get.theme.backgroundColor,
          minHeight: 2.0,
        ),
      ],
    );
  }
}
