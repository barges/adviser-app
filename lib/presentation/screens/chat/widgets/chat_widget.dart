import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_type_getter_mixin.dart';

abstract class ChatWidget extends StatelessWidget with ChatItemTypeGetter {
  final ChatItem item;

  const ChatWidget({
    super.key,
    required this.item,
  });
}
