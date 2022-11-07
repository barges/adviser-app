import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/chats/questions_type.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';

class ChatMediaWidget extends ChatWidget {
  final Duration duration;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final Stream<PlaybackDisposition>? playbackStream;
  final bool isPlaying;
  final bool isPlayingFinished;
  const ChatMediaWidget({
    super.key,
    required super.isQuestion,
    required this.duration,
    required super.type,
    super.ritualIdentifier,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.playbackStream,
    this.isPlaying = false,
    this.isPlayingFinished = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getter(
        question: const EdgeInsets.fromLTRB(12.0, 4.0, 47.0, 4.0),
        answer: const EdgeInsets.fromLTRB(47.0, 4.0, 12.0, 4.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12.0,
        ),
        decoration: BoxDecoration(
          color: getter(
            question: Get.theme.canvasColor,
            answer: Get.theme.primaryColor,
          ),
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: Row(
          children: [
            _PlayPauseBtn(
              isPlaying: isPlaying,
              onStartPlayPressed: onStartPlayPressed,
              onPausePlayPressed: onPausePlayPressed,
              color: getter(
                question: Get.theme.primaryColor,
                answer: Get.theme.backgroundColor,
              ),
              colorIcon: getter(
                question: Get.theme.backgroundColor,
                answer: Get.theme.primaryColor,
              ),
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
                              textColor: getter(
                                question: Get.theme.primaryColor,
                                answer: Get.theme.backgroundColor,
                              ),
                              backgroundColor: getter(
                                question: Get.theme.primaryColorLight,
                                answer: Get.theme.primaryColorLight,
                              ),
                              color: getter(
                                question: Get.theme.primaryColor,
                                answer: Get.theme.backgroundColor,
                              ),
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
                              type == QuestionsType.ritual &&
                                      ritualIdentifier != null
                                  ? ritualIdentifier!.sessionName
                                  : type.name,
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: getter(
                                  question: Get.theme.shadowColor,
                                  answer: Get.theme.primaryColorLight,
                                ),
                                fontSize: 12.0,
                              ),
                            ),
                            if (type == QuestionsType.ritual)
                              const SizedBox(
                                width: 6.5,
                              ),
                            if (type == QuestionsType.ritual &&
                                ritualIdentifier != null)
                              SvgPicture.asset(
                                ritualIdentifier!.iconPath,
                                width: 16.0,
                                height: 16.0,
                                color: getter(
                                  question: Get.theme.shadowColor,
                                  answer: Get.theme.primaryColorLight,
                                ),
                              ),
                            const SizedBox(
                              width: 10.55,
                            ),
                            Text(
                              duration.toString().substring(2, 7),
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: getter(
                                  question: Get.theme.shadowColor,
                                  answer: Get.theme.primaryColorLight,
                                ),
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
  final Color color;
  final Color colorIcon;
  final bool isPlaying;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  const _PlayPauseBtn({
    Key? key,
    required this.color,
    required this.colorIcon,
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
  final Color textColor;
  final Color backgroundColor;
  final Color color;
  const _PlayProgress({
    Key? key,
    required this.value,
    required this.time,
    required this.textColor,
    required this.backgroundColor,
    required this.color,
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
                color: textColor,
                fontSize: 12.0,
              ),
            ),
            const Spacer(),
            Text(
              time,
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
      ],
    );
  }
}
