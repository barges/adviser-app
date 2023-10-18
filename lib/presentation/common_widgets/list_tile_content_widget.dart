import 'package:flutter/material.dart';

import '../../app_constants.dart';
import '../../data/models/chats/attachment.dart';
import '../../data/models/chats/chat_item.dart';
import '../../data/models/enums/attachment_type.dart';
import '../../data/models/enums/message_content_type.dart';
import '../../generated/assets/assets.gen.dart';
import '../../generated/l10n.dart';
import '../../themes/app_colors.dart';
import 'app_image_widget.dart';

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
          isActive: question.isActive,
        );
        break;
      case ChatItemContentType.media:
        widget = _MediaContent(
          attachment: question.attachments!.first,
          isActive: question.isActive,
        );
        break;
      case ChatItemContentType.mediaText:
        widget = Row(
          children: [
            _MediaContent(
              attachment: question.attachments!.first,
              isActive: question.isActive,
              isSingleMedia: false,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: _TextContent(
                text: question.content ?? '',
                isActive: question.isActive,
              ),
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
            Expanded(
              child: _TextContent(
                text: question.content ?? '',
                isActive: question.isActive,
              ),
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
  final bool? isActive;

  const _TextContent({
    Key? key,
    required this.text,
    this.isActive,
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
            color: (isActive == true)
                ? AppColors.promotion
                : Theme.of(context).shadowColor,
          ),
    );
  }
}

class _MediaContent extends StatelessWidget {
  final Attachment attachment;
  final bool? isActive;
  final bool isSingleMedia;

  const _MediaContent({
    Key? key,
    required this.attachment,
    this.isActive,
    this.isSingleMedia = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isImage = attachment.type == AttachmentType.image;

    return Row(
      children: [
        isImage
            ? Container(
                height: AppConstants.iconSize,
                width: AppConstants.iconSize,
                alignment: Alignment.center,
                child: AppImageWidget(
                  uri: Uri.parse(attachment.url ?? ''),
                  height: AppConstants.iconSize,
                  width: AppConstants.iconSize,
                  loadingIndicatorHeight: 16.0,
                  radius: 4.0,
                  memCacheHeight: AppConstants.iconSize.toInt(),
                ))
            : Container(
                height: AppConstants.iconSize,
                width: AppConstants.iconSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primaryColorLight,
                ),
                child: Assets.vectors.play.svg(
                  height: AppConstants.iconSize,
                  width: AppConstants.iconSize,
                  color: theme.primaryColor,
                ),
              ),
        if (!isImage && isSingleMedia)
          Row(
            children: [
              const SizedBox(
                width: 8.0,
              ),
              Text(
                SFortunica.of(context).audioMessageFortunica,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.0,
                  color: (isActive == true)
                      ? AppColors.promotion
                      : Theme.of(context).shadowColor,
                ),
              )
            ],
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
        _MediaContent(
          attachment: attachments.first,
          isSingleMedia: false,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: VerticalDivider(
            width: 13.0,
          ),
        ),
        _MediaContent(
          attachment: attachments.last,
          isSingleMedia: false,
        ),
        const SizedBox(
          width: 8.0,
        ),
      ],
    );
  }
}
