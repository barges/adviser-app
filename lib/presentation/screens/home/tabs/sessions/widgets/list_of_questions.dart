import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_succes_widget.dart';
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
        Builder(builder: (context) {
          final int currentMarketIndex = context.select(
              (SessionsCubit cubit) => cubit.state.currentMarketIndexForPublic);
          return MarketFilterWidget(
            changeIndex: sessionsCubit.changeMarketIndexForPublic,
            currentMarketIndex: currentMarketIndex,
          );
        }),
        const Divider(
          height: 1.0,
        ),
        Builder(builder: (context) {
          final String successMessage = context
              .select((SessionsCubit cubit) => cubit.state.successMessage);
          return successMessage.isNotEmpty
              ? AppSuccessWidget(
                  message: successMessage,
                  onClose: sessionsCubit.clearSuccessMessage,
                )
              : const SizedBox.shrink();
        }),
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
                emptyListTitle: S.of(context).noQuestionsYet,
                emptyListLabel:
                    S.of(context).whenSomeoneAsksAPublicQuestionYouWillSeeThem,
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
        Builder(builder: (context) {
          final int currentMarketIndex = context.select((SessionsCubit cubit) =>
              cubit.state.currentMarketIndexForPrivate);
          return MarketFilterWidget(
            changeIndex: sessionsCubit.changeMarketIndexForPrivate,
            currentMarketIndex: currentMarketIndex,
          );
        }),
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
                emptyListTitle: S.of(context).noSessionsYet,
                emptyListLabel:
                    S.of(context).whenYouHelpYourFirstClientYouWillSeeYour,
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
  final String emptyListTitle;
  final String emptyListLabel;

  const _ListOfQuestionsWidget({
    Key? key,
    required this.questions,
    required this.onRefresh,
    required this.controller,
    required this.emptyListTitle,
    required this.emptyListLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasTaken =
        questions.firstOrNull?.status == ChatItemStatusType.taken;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          questions.isNotEmpty
              ? SliverToBoxAdapter(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(
                        AppConstants.horizontalScreenPadding),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatsListTileWidget(
                        question: questions[index],
                        needCheckStatus: hasTaken,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 12.0,
                    ),
                    itemCount: questions.length,
                  ),
                )
              : SliverFillRemaining(
                  hasScrollBody: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        EmptyListWidget(
                          title: emptyListTitle,
                          label: emptyListLabel,
                        ),
                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}
