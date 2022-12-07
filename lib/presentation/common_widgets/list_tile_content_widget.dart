import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class ListTileContentWidget extends StatelessWidget {
  final ChatItem question;

  const ListTileContentWidget({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatItemContentType contentType = question.contentType;
    Widget widget = const SizedBox();
    switch (contentType) {
      case ChatItemContentType.text:
        widget = _TextContent(
          text: question.content ?? '',
          hasUnanswered: question.hasUnanswered,
        );
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
              hasUnanswered: question.hasUnanswered,
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
              hasUnanswered: question.hasUnanswered,
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
  final bool? hasUnanswered;

  const _TextContent({
    Key? key,
    required this.text,
    this.hasUnanswered,
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
            color: (hasUnanswered != null && hasUnanswered!)
                ? AppColors.promotion
                : Theme.of(context).shadowColor,
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
    final ThemeData theme = Theme.of(context);
    final bool isImage = attachment.type == AttachmentType.image;

    return Row(
      children: [
        Container(
          height: AppConstants.iconSize,
          width: AppConstants.iconSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: isImage ? BoxShape.rectangle : BoxShape.circle,
            color: theme.primaryColorLight,
            borderRadius: isImage ? BorderRadius.circular(4.0) : null,
          ),
          child: isImage
              ? CachedNetworkImage(imageUrl: attachment.url ?? '')
              : Assets.vectors.play.svg(
                  height: AppConstants.iconSize,
                  width: AppConstants.iconSize,
                  color: theme.primaryColor,
                ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        if (!isImage)
          Text(
            S.of(context).audioMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14.0,
              color: AppColors.promotion,
            ),
          )
      ],
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
        const SizedBox(
          width: 8.0,
        ),
      ],
    );
  }
}
