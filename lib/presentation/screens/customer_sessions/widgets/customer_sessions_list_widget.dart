import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_constants.dart';
import '../../../../data/models/chats/chat_item.dart';
import '../customer_sessions_cubit.dart';
import 'customer_session_tile_widget.dart';

class CustomerSessionsListWidget extends StatelessWidget {
  final List<ChatItem> questions;

  const CustomerSessionsListWidget({Key? key, required this.questions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerSessionsCubit customerSessionsCubit =
        context.read<CustomerSessionsCubit>();
    return RefreshIndicator(
        onRefresh: () async {
          customerSessionsCubit.getPrivateQuestions(refresh: true);
        },
        child: ListView.separated(
          controller: customerSessionsCubit.questionsScrollController,
          padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return CustomerSessionListTileWidget(question: questions[index]);
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 12.0,
          ),
          itemCount: questions.length,
        ));
  }
}
