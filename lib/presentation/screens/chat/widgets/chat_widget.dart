import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_type_getter_mixin.dart';

abstract class ChatWidget extends StatelessWidget with ChatItemTypeGetter {
  final ChatItem item;

  const ChatWidget({
    super.key,
    required this.item,
  });

  @override
  bool get isAnswer => item.isAnswer;

  DateTime get createdAt =>
      DateTime.tryParse(item.createdAt ?? '') ?? DateTime.now();

  EdgeInsetsGeometry get paddingItem => getterType(
        question: const EdgeInsets.fromLTRB(12.0, 4.0, 48.0, 4.0),
        answer: const EdgeInsets.fromLTRB(48.0, 4.0, 12.0, 4.0),
      );

  Color getColorItem(BuildContext context) => getterType(
        question: Theme.of(context).canvasColor,
        answer: Theme.of(context).primaryColor,
      );
}
