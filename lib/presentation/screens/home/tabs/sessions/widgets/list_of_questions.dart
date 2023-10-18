import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app_constants.dart';
import '../../../../../../data/models/app_error/app_error.dart';
import '../../../../../../data/models/app_success/app_success.dart';
import '../../../../../../data/models/chats/chat_item.dart';
import '../../../../../../data/models/enums/chat_item_status_type.dart';
import '../../../../../../data/models/enums/markets_type.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../main_cubit.dart';
import '../../../../../common_widgets/empty_list_widget.dart';
import '../../../../../common_widgets/market_filter_widget.dart';
import '../../../../../common_widgets/messages/app_error_widget.dart';
import '../../../../../common_widgets/messages/app_success_widget.dart';
import '../sessions_cubit.dart';
import 'list_tile/chats_list_tile_widget.dart';

class ListOfQuestions extends StatelessWidget {
  final ScrollController publicQuestionsScrollController;
  final ScrollController conversationsScrollController;

  const ListOfQuestions({
    Key? key,
    required this.publicQuestionsScrollController,
    required this.conversationsScrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int index =
        context.select((SessionsCubit cubit) => cubit.state.currentOptionIndex);

    return IndexedStack(
      index: index,
      children: [
        _PublicQuestionsListWidget(
          publicQuestionsScrollController: publicQuestionsScrollController,
        ),
        _PrivateQuestionsListWidget(
          conversationsScrollController: conversationsScrollController,
        ),
      ],
    );
  }
}

class _PublicQuestionsListWidget extends StatelessWidget {
  final ScrollController publicQuestionsScrollController;

  const _PublicQuestionsListWidget({
    Key? key,
    required this.publicQuestionsScrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionsCubit sessionsCubit = context.read<SessionsCubit>();
    return Column(
      children: [
        Builder(builder: (context) {
          final int currentMarketIndex = context.select(
              (SessionsCubit cubit) => cubit.state.currentMarketIndexForPublic);
          final List<MarketsType> userMarkets =
              context.select((SessionsCubit cubit) => cubit.state.userMarkets);
          return MarketFilterWidget(
            userMarkets: userMarkets,
            changeIndex: sessionsCubit.changeMarketIndexForPublic,
            currentMarketIndex: currentMarketIndex,
            isExpanded: true,
          );
        }),
        const Divider(
          height: 1.0,
        ),
        Builder(builder: (context) {
          final AppError appError =
              context.select((MainCubit cubit) => cubit.state.appError);
          return AppErrorWidget(
            errorMessage: appError.getMessage(context),
            close: sessionsCubit.closeErrorWidget,
          );
        }),
        Builder(builder: (context) {
          final AppSuccess appSuccess =
              context.select((SessionsCubit cubit) => cubit.state.appSuccess);
          return AppSuccessWidget(
            message: appSuccess.getMessage(context),
            onClose: sessionsCubit.clearSuccessMessage,
          );
        }),
        Builder(
          builder: (context) {
            final List<ChatItem>? publicQuestions = context
                .select((SessionsCubit cubit) => cubit.state.publicQuestions);
            return Expanded(
              child: _ListOfQuestionsWidget(
                controller: publicQuestionsScrollController,
                questions: publicQuestions,
                onRefresh: () async {
                  sessionsCubit.getPublicQuestions(refresh: true);
                },
                emptyListTitle: SFortunica.of(context).noQuestionsYetFortunica,
                emptyListLabel: SFortunica.of(context)
                    .whenSomeoneAsksAPublicQuestionYouLlSeeThemOnThisListFortunica,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PrivateQuestionsListWidget extends StatelessWidget {
  final ScrollController conversationsScrollController;

  const _PrivateQuestionsListWidget({
    Key? key,
    required this.conversationsScrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionsCubit sessionsCubit = context.read<SessionsCubit>();
    return Column(
      children: [
        Builder(builder: (context) {
          final int currentMarketIndex = context.select((SessionsCubit cubit) =>
              cubit.state.currentMarketIndexForPrivate);
          final List<MarketsType> userMarkets =
              context.select((SessionsCubit cubit) => cubit.state.userMarkets);
          return MarketFilterWidget(
            userMarkets: userMarkets,
            changeIndex: sessionsCubit.changeMarketIndexForPrivate,
            currentMarketIndex: currentMarketIndex,
            isExpanded: true,
          );
        }),
        const Divider(
          height: 1.0,
        ),
        Builder(builder: (context) {
          final AppError appError =
              context.select((MainCubit cubit) => cubit.state.appError);
          return AppErrorWidget(
            errorMessage: appError.getMessage(context),
            close: sessionsCubit.closeErrorWidget,
          );
        }),
        Builder(
          builder: (context) {
            final List<ChatItem>? conversationsList = context
                .select((SessionsCubit cubit) => cubit.state.conversationsList);
            return Expanded(
              child: _ListOfQuestionsWidget(
                controller: conversationsScrollController,
                questions: conversationsList,
                isPublic: false,
                onRefresh: () async {
                  sessionsCubit.getConversations(refresh: true);
                },
                emptyListTitle: SFortunica.of(context).noSessionsYetFortunica,
                emptyListLabel: SFortunica.of(context)
                    .yourClientSessionHistoryWillAppearHereFortunica,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ListOfQuestionsWidget extends StatelessWidget {
  final List<ChatItem>? questions;
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
        isPublic && questions?.firstOrNull?.status == ChatItemStatusType.taken;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        controller: controller,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          questions == null
              ? const SliverToBoxAdapter(child: SizedBox.shrink())
              : questions!.isNotEmpty
                  ? SliverToBoxAdapter(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(
                            AppConstants.horizontalScreenPadding),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return ChatsListTileWidget(
                            question: questions![index],
                            needCheckTakenStatus: hasTaken,
                            isPublic: isPublic,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                          height: 12.0,
                        ),
                        itemCount: questions!.length,
                      ),
                    )
                  : SliverFillRemaining(
                      hasScrollBody: false,
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
