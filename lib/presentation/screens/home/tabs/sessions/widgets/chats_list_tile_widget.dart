import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class ChatsListTileWidget extends StatelessWidget {
  final ChatItem question;

  const ChatsListTileWidget({Key? key, required this.question})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (question.clientID != null) {
                Get.toNamed(AppRoutes.customerProfile,
                    arguments: question.clientID);
              }
            },
            child: SizedBox(
              width: 48.0,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  SvgPicture.asset(
                    question.clientInformation?.zodiac?.imagePath(context) ??
                        '',
                    height: 48.0,
                  ),

                  ///TODO: need change
                  // CircleAvatar(
                  //     radius: 8.0,
                  //     backgroundColor: Theme.of(context).canvasColor,
                  //
                  //
                  //     child: Assets.vectors.ritual.svg())
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
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
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontSize: 15.0,
                                ),
                      ),
                    ),
                    Text(
                      (question.updatedAt ?? '').parseDateTimePattern1,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).shadowColor,
                            fontSize: 12.0,
                          ),
                    )
                  ],
                ),
                const SizedBox(height: 4.0),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: AppConstants.iconSize,
                          child: _ContentWidget(
                            question: question,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 32.0,
                      ),
                      if (question.type != ChatItemType.history)
                        Container(
                          height: 8.0,
                          width: 8.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.promotion,
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  final ChatItem question;

  const _ContentWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatItemContentType contentType = question.contentType;
    Widget widget = const SizedBox();
    switch (contentType) {
      case ChatItemContentType.text:
        widget = _TextContent(text: question.content ?? '');
        break;
      case ChatItemContentType.media:
        widget = _MediaContent(
          attachment: question.attachments!.first,
        );
        break;
      case ChatItemContentType.mediaText:
        widget = Row(
          children: [
            _MediaContent(
              attachment: question.attachments!.first,
            ),
            const SizedBox(
              width: 8.0,
            ),
            _TextContent(
              text: question.content ?? '',
            ),
          ],
        );
        break;
      case ChatItemContentType.mediaMediaText:
        widget = Row(
          children: [
            _MediaMediaContent(
              attachments: question.attachments!,
            ),
            const SizedBox(
              width: 8.0,
            ),
            _TextContent(
              text: question.content ?? '',
            ),
          ],
        );
        break;
      case ChatItemContentType.mediaMedia:
        widget = _MediaMediaContent(
          attachments: question.attachments!,
        );
        break;
    }

    return widget;
  }
}

class _TextContent extends StatelessWidget {
  final String text;

  const _TextContent({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            color: Theme.of(context).shadowColor,
          ),
    );
  }
}

class _MediaContent extends StatelessWidget {
  final Attachment attachment;

  const _MediaContent({
    Key? key,
    required this.attachment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isImage = attachment.type == AttachmentType.image;

    return Container(
      height: AppConstants.iconSize,
      width: AppConstants.iconSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: isImage ? BoxShape.rectangle : BoxShape.circle,
        color: Theme.of(context).primaryColorLight,
        borderRadius: isImage ? BorderRadius.circular(4.0) : null,
      ),
      child: isImage
          ? CachedNetworkImage(imageUrl: attachment.url ?? '')
          : Assets.vectors.play.svg(
              height: AppConstants.iconSize,
              width: AppConstants.iconSize,
              color: Theme.of(context).primaryColor,
            ),
    );
  }
}

class _MediaMediaContent extends StatelessWidget {
  final List<Attachment> attachments;

  const _MediaMediaContent({
    Key? key,
    required this.attachments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MediaContent(attachment: attachments.first),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: VerticalDivider(
            width: 13.0,
          ),
        ),
        _MediaContent(attachment: attachments.last),
      ],
    );
  }
}
