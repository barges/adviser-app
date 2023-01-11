import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/history_ui_model.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/empty_history_list_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/history_list_started_from_begin_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/history_list_started_with_story_id.dart';

class HistoryWidget extends StatelessWidget {
  final String clientId;
  final String? storyId;

  const HistoryWidget({
    Key? key,
    required this.clientId,
    this.storyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit(
        getIt.get<ChatsRepository>(),
        clientId,
        storyId,
      ),
      child: Builder(builder: (context) {
        if (storyId != null) {
          final List<HistoryUiModel>? topHistoriesList = context
              .select((HistoryCubit cubit) => cubit.state.topHistoriesList);

          if (topHistoriesList == null) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            );
          }
          if (topHistoriesList.isEmpty) {
            return const EmptyHistoryListWidget();
          }

          return HistoryListStartedWithStoryIdWidget(
            topHistoriesList: topHistoriesList,
          );
        } else {
          final List<HistoryUiModel>? bottomHistoriesList = context
              .select((HistoryCubit cubit) => cubit.state.bottomHistoriesList);

          if (bottomHistoriesList == null) {
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            );
          }
          if (bottomHistoriesList.isEmpty) {
            return const EmptyHistoryListWidget();
          }

          return HistoryListStartedFromBeginWidget(
            historiesList: bottomHistoriesList,
          );
        }
      }),
    );
  }
}
