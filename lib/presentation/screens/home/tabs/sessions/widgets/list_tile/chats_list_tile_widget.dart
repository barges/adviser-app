import 'package:flutter/material.dart';

import '../../../../../../../data/models/chats/chat_item.dart';
import 'private_chats_list_tile_widget.dart';
import 'public_chats_list_tile_widget.dart';

class ChatsListTileWidget extends StatelessWidget {
  final ChatItem question;
  final bool needCheckTakenStatus;
  final bool isPublic;

  const ChatsListTileWidget({
    Key? key,
    required this.question,
    this.needCheckTakenStatus = false,
    this.isPublic = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPublic) {
      return PublicChatsListTileWidget(
        question: question,
        needCheckTakenStatus: needCheckTakenStatus,
      );
    } else {
      return PrivateChatsListTileWidget(
        question: question,
      );
    }
  }
}
