import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/is_delivered_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/messages/reaction_widget.dart';
import 'package:zodiac/zodiac_extensions.dart';

class ImageMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  final bool hideLoader;

  const ImageMessageWidget({
    Key? key,
    required this.chatMessageModel,
    this.hideLoader = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOutgoing = chatMessageModel.isOutgoing;
    return isOutgoing
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ReactionWidget(
                  chatMessageModel: chatMessageModel,
                ),
              ),
              _ImageWidget(
                chatMessageModel: chatMessageModel,
                hideLoader: hideLoader,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ImageWidget(
                chatMessageModel: chatMessageModel,
                hideLoader: hideLoader,
              ),
              Expanded(
                child: ReactionWidget(
                  chatMessageModel: chatMessageModel,
                ),
              ),
            ],
          );
  }
}

class _ImageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;
  final bool hideLoader;

  const _ImageWidget({
    Key? key,
    required this.chatMessageModel,
    required this.hideLoader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        AppImageWidget(
          height: 138.0,
          width: 194.0,
          memCacheHeight: 138,
          radius: AppConstants.buttonRadius,
          uri: Uri.parse(chatMessageModel.mainImage ??
              chatMessageModel.thumbnail ??
              chatMessageModel.image ??
              ''),
          canBeOpenedInFullScreen: true,
        ),
        Positioned(
          bottom: 4.0,
          right: 4.0,
          child: Container(
            height: 18.0,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
              color: AppColors.black.withOpacity(0.4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chatMessageModel.utc?.chatListTime ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12.0,
                    color: theme.backgroundColor,
                  ),
                ),
                IsDeliveredWidget(
                  chatMessageModel: chatMessageModel,
                  color: theme.backgroundColor,
                  hideLoader: hideLoader,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
