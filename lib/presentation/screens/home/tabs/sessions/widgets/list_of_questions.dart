import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/questions_type.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/chats_list_tile_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/market_filter_widget.dart';

class ListOfQuestions extends StatelessWidget {
  const ListOfQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int index =
        context.select((SessionsCubit cubit) => cubit.state.currentOptionIndex);

    return IndexedStack(
      index: index,
      children: const [
        _PublicQuestionsListWidget(),
       _PrivateQuestionsListWidget(),
      ],
    );
  }
}

class _PublicQuestionsListWidget extends StatelessWidget {
  const _PublicQuestionsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionsCubit sessionsCubit = context.read<SessionsCubit>();
    return Column(
      children: [
        MarketFilterWidget(
            isExpanded: true,
            changeIndex: sessionsCubit.changeMarketIndexForPublic,
          ),
        const Divider(
          height: 1.0,
        ),
        Builder(
          builder: (context) {
            final List<ChatItem> publicQuestions = context
                .select((SessionsCubit cubit) => cubit.state.publicQuestions);
            return Expanded(
              child: _ListOfQuestionsWidget(
                controller: sessionsCubit.publicQuestionsController,
                questions: publicQuestions,
                onRefresh: () async {
                  sessionsCubit.getPublicQuestions(refresh: true);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PrivateQuestionsListWidget extends StatelessWidget {
  const _PrivateQuestionsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionsCubit sessionsCubit = context.read<SessionsCubit>();
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Builder(builder: (context) {
                final int currentFilterIndex = context.select(
                    (SessionsCubit cubit) => cubit.state.currentFilterIndex);

                return ListOfFiltersWidget(
                  withMarketFilter: true,
                  currentFilterIndex: currentFilterIndex,
                  onTapToFilter: sessionsCubit.changeFilterIndex,
                  filters:
                      sessionsCubit.filters.map((e) => e.filterName).toList(),
                );
              }),
              MarketFilterWidget(
                changeIndex: sessionsCubit.changeMarketIndexForPrivate,
              ),
            ],
          ),
        ),
        const Divider(
          height: 1.0,
        ),
        Builder(
          builder: (context) {
            final List<ChatItem> privateQuestionsWithHistory = context.select(
                (SessionsCubit cubit) =>
                    cubit.state.privateQuestionsWithHistory);
            return Expanded(
              child: _ListOfQuestionsWidget(
                controller: sessionsCubit.privateQuestionsController,
                questions: privateQuestionsWithHistory,
                onRefresh: () async {
                  sessionsCubit.getPrivateQuestions(refresh: true);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ListOfQuestionsWidget extends StatelessWidget {
  final List<ChatItem> questions;
  final RefreshCallback onRefresh;
  final ScrollController controller;

  const _ListOfQuestionsWidget({
    Key? key,
    required this.questions,
    required this.onRefresh,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ListView.separated(
              padding:
                  const EdgeInsets.all(AppConstants.horizontalScreenPadding),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,

              itemBuilder: (BuildContext context, int index) {
                return ChatsListTileWidget(question: questions[index]);
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(
                height: 12.0,
              ),
              itemCount: questions.length,
            ),
          ),
        ],
      ),
    );
  }
}
