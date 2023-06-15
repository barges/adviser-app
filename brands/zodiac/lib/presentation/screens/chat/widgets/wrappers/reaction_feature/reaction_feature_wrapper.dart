import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hive/hive.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/widgets/chat_message/chat_message_widget.dart';

class ReactionFeatureWrapper extends StatefulWidget {
  final ChatMessageModel chatMessageModel;

  const ReactionFeatureWrapper({Key? key, required this.chatMessageModel})
      : super(key: key);

  @override
  State<ReactionFeatureWrapper> createState() => _ReactionFeatureWrapperState();
}

class _ReactionFeatureWrapperState extends State<ReactionFeatureWrapper> {
  final GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FocusedMenuHolder(
      key: key,
      onPressed: () {},
      animateMenuItems: true,
      menuWidth: 244.0,
      menuOffset: 8.0,
      menuItemExtent: 44.0,
      menuBoxDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
      ),
      menuItems: [
        FocusedMenuItem(
            title: Text('Reply'),
            onPressed: () {},
            backgroundColor: theme.unselectedWidgetColor),
        FocusedMenuItem(
            title: Text('Cancel'),
            onPressed: () {},
            backgroundColor: theme.unselectedWidgetColor),
      ],
      child: ChatMessageWidget(
        chatMessageModel: widget.chatMessageModel,
      ),
    );
  }
}
