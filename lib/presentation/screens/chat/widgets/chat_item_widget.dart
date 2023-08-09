import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/audio_players/chat_audio_player_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_background_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_footer_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_area_widget.dart';

class ChatItemWidget extends StatefulWidget {
  final ChatItem item;

  const ChatItemWidget({
    super.key,
    required this.item,
  });

  @override
  State<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends State<ChatItemWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ChatItemBackgroundWidget(
      isNotSent: !widget.item.isSent,
      padding: widget.item.isAnswer
          ? const EdgeInsets.only(left: 36.0)
          : const EdgeInsets.only(right: 36.0),
      color: widget.item.isAnswer
          ? Theme.of(context).primaryColor
          : Theme.of(context).canvasColor,
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (widget.item.content?.isNotEmpty == true)
            Padding(
              padding: EdgeInsets.only(
                  bottom:
                      widget.item.attachments?.isNotEmpty == true ? 5.0 : 18.0),
              child: ChatTextAreaWidget(
                content: widget.item.content!,
                color: widget.item.isAnswer
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).hoverColor,
              ),
            ),
          if (widget.item.attachments?.isNotEmpty == true)
            Column(
              children:
                  widget.item.attachments!.mapIndexed((index, attachment) {
                if (attachment.type == AttachmentType.image) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.item.attachments!.length > 1 &&
                              index < widget.item.attachments!.length - 1
                          ? 12.0
                          : 20.0,
                    ),
                    child: AppImageWidget(
                      uri: Uri.parse(attachment.url ?? ''),
                      height: 134.0,
                      memCacheHeight: 134,
                      radius: 8.0,
                      canBeOpenedInFullScreen: true,
                    ),
                  );
                } else if (attachment.type == AttachmentType.audio) {
                  return ChatAudioPlayerWidget(
                    isQuestion: !widget.item.isAnswer,
                    attachment: attachment,
                    player: context.read<ChatCubit>().audioPlayer,
                  );
                }

                return const SizedBox();
              }).toList(),
            ),
          Builder(builder: (context) {
            final int? isAudio = widget.item.attachments
                ?.indexWhere((element) => element.type == AttachmentType.audio);
            return SizedBox(
              height: widget.item.attachments?.isNotEmpty == true &&
                      isAudio != null &&
                      isAudio != -1
                  ? 14.0
                  : 5.0,
            );
          }),
        ]),
        Positioned(
          right: 0.0,
          left: 0.0,
          bottom: 0.0,
          child: ChatItemFooterWidget(
            type: widget.item.type,
            createdAt: widget.item.createdAt ?? DateTime.now(),
            ritualIdentifier: widget.item.ritualIdentifier,
            color: widget.item.isAnswer
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).shadowColor,
            isSent: widget.item.isSent,
          ),
        ),
      ]),
    );
  }

  @override
  bool get wantKeepAlive => widget.item.isAudio ? true : false;
}
