import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/history_ui_model.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/sliver_history_list_widget.dart';

const Key _centerKey = ValueKey('second-sliver-list');

class HistoryListStartedWithStoryIdWidget extends StatelessWidget {
  final List<HistoryUiModel> bottomHistoriesList;

  const HistoryListStartedWithStoryIdWidget({
    Key? key,
    required this.bottomHistoriesList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HistoryCubit historyCubit = context.read<HistoryCubit>();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: historyCubit.historyMessagesScrollController,
        center: _centerKey,
        slivers: <Widget>[
          Builder(builder: (context) {
            final List<HistoryUiModel>? topHistoriesList = context.select(
                (HistoryCubit cubit) => cubit.state.topHistoriesList);
            if (topHistoriesList != null) {
             return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  sliver: SliverHistoryListWidget(
                    historiesList: topHistoriesList,
                  ));
            } else {
              return const SliverToBoxAdapter(
                child: SizedBox.shrink(),
              );
            }
          }),
          SliverPadding(
              key: _centerKey,
              padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 16.0),
              sliver:
              SliverHistoryListWidget(historiesList: bottomHistoriesList)),
        ],
      ),
    );
  }
}
