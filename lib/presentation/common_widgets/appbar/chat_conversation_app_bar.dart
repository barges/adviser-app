import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';

class ChatConversationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? backIcon;
  final String? backButtonText;
  final Brand? selectedBrand;
  final ChatItem question;

  const ChatConversationAppBar({
    Key? key,
    required this.title,
    this.backButtonText,
    this.backIcon,
    this.selectedBrand,
    required this.question,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppIconButton(
            icon: backIcon ?? Assets.vectors.arrowLeft.path,
            onTap: Get.back,
          ),
          Column(
            children: [
              Row(
                children: [
                  if (selectedBrand != null)
                    SvgPicture.asset(
                      selectedBrand!.icon,
                      height: 17.0,
                    ),
                  const SizedBox(width: 12.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).hoverColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                "Paid Chat ${DateFormat(dateFormat).format(question.updatedAt ?? DateTime.now()).parseDateTimeChat}",
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w200,
                  color: Theme.of(context).shadowColor,
                ),
              ),
            ],
          ),
          SvgPicture.asset(
            question.clientInformation?.zodiac?.imagePath(context) ?? '',
            width: 28.0,
          ),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
