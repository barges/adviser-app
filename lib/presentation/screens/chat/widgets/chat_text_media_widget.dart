import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_bg_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/rect_circle_image.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_player.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_area_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/footer_chat_widget.dart';

class ChatTextMediaWidget extends ChatWidget {
  final String? content;
  const ChatTextMediaWidget({
    super.key,
    required super.item,
    required super.isQuestion,
    required super.createdAt,
    required super.type,
    super.ritualIdentifier,
    this.content = '',
  });

  @override
  Widget build(BuildContext context) {
    return ChatItemBg(
      border: true,
      padding: getter(
        question: const EdgeInsets.fromLTRB(12.0, 4.0, 48.0, 4.0),
        answer: const EdgeInsets.fromLTRB(48.0, 4.0, 12.0, 4.0),
      ),
      color: getter(
        question: Get.theme.canvasColor,
        answer: Get.theme.primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatTextAreaWidget(
            content: content,
            color: getter(
              question: Get.theme.hoverColor,
              answer: Get.theme.backgroundColor,
            ),
          ),
          if (item.getImageUrl(1) != null || item.getImageUrl(2) != null)
            const SizedBox(height: 12.0),
          if (item.getAudioUrl(1) != null || item.getAudioUrl(2) != null)
            const SizedBox(height: 12.0),
          if (item.getImageUrl(1) != null)
            RectCircleImage(
              item.getImageUrl(1)!,
              height: 134.0,
            ),
          if (item.getImageUrl(1) != null) const SizedBox(height: 12.0),
          //if (item.getImageUrl(1) != null) const SizedBox(height: 12.0),
          if (item.getImageUrl(2) != null)
            RectCircleImage(
              item.getImageUrl(2)!,
              height: 134.0,
            ),
          if (item.getImageUrl(2) != null) const SizedBox(height: 12.0),
          //if (item.getImageUrl(2) != null) const SizedBox(height: 12.0),
          //
          if (item.getAudioUrl(1) != null)
            ChatItemPlayer(
              //onStartPlayPressed: onStartPlayPressed,
              //onPausePlayPressed: onPausePlayPressed,
              //isPlaying: isPlaying,
              //isPlayingFinished: isPlayingFinished,
              // ignore: prefer_const_constructors
              duration: Duration(),
              // playbackStream: playbackStream,
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
              // onStartPlayPressed: onStartPlayPressed,
              //onPausePlayPressed: onPausePlayPressed,
              //isPlaying: isPlaying,
              // isPlayingFinished: isPlayingFinished,
              duration: const Duration(),
              //playbackStream: playbackStream,
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
          Row(
            children: [
              const Spacer(),
              FooterChatWidget(
                type: type,
                createdAt: createdAt,
                ritualIdentifier: ritualIdentifier,
                color: getter(
                  question: Get.theme.shadowColor,
                  answer: Get.theme.primaryColorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
