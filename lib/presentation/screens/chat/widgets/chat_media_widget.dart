import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_bg_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/rect_circle_image.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_player.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/footer_chat_widget.dart';

class ChatMediaWidget extends ChatWidget {
  final String? audioUrl;
  final String? imageUrl;
  final Duration duration;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final Stream<PlaybackDisposition>? playbackStream;
  final bool isPlaying;
  final bool isPlayingFinished;
  const ChatMediaWidget({
    super.key,
    required super.item,
    required super.isQuestion,
    required super.type,
    required super.createdAt,
    required this.duration,
    super.ritualIdentifier,
    this.imageUrl,
    this.audioUrl,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.playbackStream,
    this.isPlaying = false,
    this.isPlayingFinished = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChatItemBg(
      padding: getter(
        question: const EdgeInsets.fromLTRB(12.0, 4.0, 48.0, 4.0),
        answer: const EdgeInsets.fromLTRB(48.0, 4.0, 12.0, 4.0),
      ),
      color: getter(
        question: Get.theme.canvasColor,
        answer: Get.theme.primaryColor,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              if (item.getImageUrl(1) != null)
                RectCircleImage(
                  item.getImageUrl(1)!,
                  height: 134.0,
                ),
              if (item.getImageUrl(1) != null) const SizedBox(height: 12.0),
              if (item.getImageUrl(1) != null) const SizedBox(height: 12.0),
              if (item.getImageUrl(2) != null)
                RectCircleImage(
                  item.getImageUrl(2)!,
                  height: 134.0,
                ),
              if (item.getImageUrl(2) != null) const SizedBox(height: 12.0),
              if (item.getImageUrl(2) != null) const SizedBox(height: 12.0),
              //
              if (item.getAudioUrl(1) != null)
                ChatItemPlayer(
                  onStartPlayPressed: onStartPlayPressed,
                  onPausePlayPressed: onPausePlayPressed,
                  isPlaying: isPlaying,
                  isPlayingFinished: isPlayingFinished,
                  duration: duration,
                  playbackStream: playbackStream,
                  textColor: getter(
                    question: Get.theme.primaryColor,
                    answer: Get.theme.backgroundColor,
                  ),
                  colorProgressIndicator: getter(
                    question: Get.theme.primaryColor,
                    answer: Get.theme.backgroundColor,
                  ),
                  bgColorProgressIndicator: getter(
                    question: Get.theme.primaryColorLight,
                    answer: Get.theme.primaryColorLight,
                  ),
                  colorIcon: getter(
                    question: Get.theme.backgroundColor,
                    answer: Get.theme.primaryColor,
                  ),
                  colorBtn: getter(
                    question: Get.theme.primaryColor,
                    answer: Get.theme.backgroundColor,
                  ),
                ),
              if (item.getAudioUrl(2) != null)
                ChatItemPlayer(
                  onStartPlayPressed: onStartPlayPressed,
                  onPausePlayPressed: onPausePlayPressed,
                  isPlaying: isPlaying,
                  isPlayingFinished: isPlayingFinished,
                  duration: duration,
                  playbackStream: playbackStream,
                  textColor: getter(
                    question: Get.theme.primaryColor,
                    answer: Get.theme.backgroundColor,
                  ),
                  colorProgressIndicator: getter(
                    question: Get.theme.primaryColor,
                    answer: Get.theme.backgroundColor,
                  ),
                  bgColorProgressIndicator: getter(
                    question: Get.theme.primaryColorLight,
                    answer: Get.theme.primaryColorLight,
                  ),
                  colorIcon: getter(
                    question: Get.theme.backgroundColor,
                    answer: Get.theme.primaryColor,
                  ),
                  colorBtn: getter(
                    question: Get.theme.primaryColor,
                    answer: Get.theme.backgroundColor,
                  ),
                ),
            ],
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: FooterChatWidget(
              type: type,
              createdAt: createdAt,
              ritualIdentifier: ritualIdentifier,
              color: getter(
                question: Get.theme.shadowColor,
                answer: Get.theme.primaryColorLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
