import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/sessions_type.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_widget.dart';

class ChatTextWidget extends ChatWidget {
  final String? content;
  const ChatTextWidget({
    super.key,
    required super.isQuestion,
    required super.createdAt,
    required super.type,
    super.ritualIdentifier,
    this.content = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getter(
        question: const EdgeInsets.fromLTRB(12.0, 4.0, 48.0, 4.0),
        answer: const EdgeInsets.fromLTRB(48.0, 4.0, 12.0, 4.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: getter(
            question: Get.theme.canvasColor,
            answer: Get.theme.primaryColor,
          ),
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          border: Border.all(
            width: 1,
            color: Get.theme.primaryColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content ?? 'none',
              style: Get.textTheme.bodySmall?.copyWith(
                color: getter(
                  question: Get.theme.hoverColor,
                  answer: Get.theme.backgroundColor,
                ),
                fontSize: 15.0,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  type == SessionsTypes.ritual && ritualIdentifier != null
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
                if (type == SessionsTypes.ritual)
                  const SizedBox(
                    width: 6.5,
                  ),
                if (type == SessionsTypes.ritual && ritualIdentifier != null)
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
                  width: 8,
                ),
                Text(
                  createdAt.toString(),
                  //'${createdAt.hour}:${createdAt.minute}',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: getter(
                      question: Get.theme.shadowColor,
                      answer: Get.theme.primaryColorLight,
                    ),
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
