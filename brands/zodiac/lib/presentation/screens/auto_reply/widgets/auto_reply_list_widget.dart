import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/chat/private_message_model.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_cubit.dart';
import 'package:zodiac/presentation/screens/auto_reply/widgets/auto_reply_list_item_widget.dart';

class AutoReplyListWidget extends StatelessWidget {
  const AutoReplyListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PrivateMessageModel>? messages =
        context.select((AutoReplyCubit cubit) => cubit.state.messages);

    if (messages != null) {
      return ListView.separated(
        itemCount: messages.length,
        itemBuilder: (context, index) => AutoReplyListItemWidget(
          message: messages[index].message ?? '',
          id: messages[index].id,
        ),
        separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
