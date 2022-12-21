import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_success/app_success.dart';
import 'package:shared_advisor_interface/data/models/app_success/empty_success.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/empty_list_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_succes_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/list_tile/chats_list_tile_widget.dart';
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
          final AppSuccess appSuccess =
              context.select((SessionsCubit cubit) => cubit.state.appSuccess);
          return appSuccess is! EmptySuccess
              ? AppSuccessWidget(
                  message: appSuccess.getMessage(context),
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
                controller: sessionsCubit.publicQuestionsScrollController,
                questions: publicQuestions,
                onRefresh: () async {
                  sessionsCubit.getPublicQuestions(refresh: true);
                },
                emptyListTitle: S.of(context).noQuestionsYet,
                emptyListLabel: S
                    .of(context)
                    .whenSomeoneAsksAPublicQuestionYouLlSeeThemOnThisList,
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
            final List<ChatItem> conversationsList = context
                .select((SessionsCubit cubit) => cubit.state.conversationsList);
            return Expanded(
              child: _ListOfQuestionsWidget(
                controller: sessionsCubit.conversationsScrollController,
                questions: conversationsList,
                isPublic: false,
                onRefresh: () async {
                  sessionsCubit.getConversations(refresh: true);
                },
                emptyListTitle: S.of(context).noSessionsYet,
                emptyListLabel:
                    S.of(context).yourClientSessionHistoryWillAppearHere,
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
  final bool isPublic;

  const _ListOfQuestionsWidget({
    Key? key,
    required this.questions,
    required this.onRefresh,
    required this.controller,
    required this.emptyListTitle,
    required this.emptyListLabel,
    this.isPublic = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasTaken =
        isPublic && questions.firstOrNull?.status == ChatItemStatusType.taken;

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
                        needCheckTakenStatus: hasTaken,
                        isPublic: isPublic,
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
