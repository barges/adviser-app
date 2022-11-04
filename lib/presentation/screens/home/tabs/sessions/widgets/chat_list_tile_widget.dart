import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/chats/question.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class ChatListTileWidget extends StatelessWidget {
  final Question question;

  const ChatListTileWidget({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      GestureDetector(
        onTap: () {
          if (question.clientID != null) {
            Get.toNamed(AppRoutes.userProfile, arguments: question.clientID);
          }
        },
        child: SizedBox(
            width: 44.0,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                SvgPicture.asset(
                    question.clientInformation?.zodiac
                            ?.imagePath ??
                        '',
                    width: 44.0),
                CircleAvatar(
                    radius: 8.0,
                    backgroundColor: Get.theme.canvasColor,
                    child: Assets.vectors.ritual.svg())
              ],
            )),
      ),
      const SizedBox(width: 14.0),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question.clientName ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  (question.updatedAt ?? '').parseDateTimePattern1,
                  style: Get.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Get.theme.shadowColor),
                )
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    question.content ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Get.theme.shadowColor),
                  ),
                ),
                /*  if (notificationsNumber > 0)
                  CircleAvatar(
                    maxRadius: 10,
                    minRadius: 9,
                    backgroundColor: AppColors.promotion,
                    child: Text(
                      '$notificationsNumber',
                      style: Get.textTheme.displaySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  )*/
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.horizontalScreenPadding),
              child: Divider(
                height: 1.0,
                thickness: 1.0,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
