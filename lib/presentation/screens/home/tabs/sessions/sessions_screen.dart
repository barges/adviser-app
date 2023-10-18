import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app_constants.dart';
import '../../../../../data/cache/fortunica_caching_manager.dart';
import '../../../../../data/models/enums/fortunica_user_status.dart';
import '../../../../../data/models/user_info/user_status.dart';
import '../../../../../domain/repositories/fortunica_chats_repository.dart';
import '../../../../../generated/assets/assets.gen.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../infrastructure/di/inject_config.dart';
import '../../../../../main_cubit.dart';
import '../../../../../services/connectivity_service.dart';
import '../../../../common_widgets/appbar/home_app_bar.dart';
import '../../../../common_widgets/buttons/app_icon_button.dart';
import '../../../../common_widgets/buttons/choose_option_widget.dart';
import '../../../../common_widgets/no_connection_widget.dart';
import '../../home_cubit.dart';
import 'sessions_cubit.dart';
import 'widgets/list_of_questions.dart';
import 'widgets/search/search_list_widget.dart';
import 'widgets/status_not_live_widget.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final ScrollController publicQuestionsScrollController = ScrollController();
  final ScrollController conversationsScrollController = ScrollController();

  late final StreamSubscription<bool> _updateSessionsSubscription;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) {
        final MainCubit mainCubit = fortunicaGetIt.get<MainCubit>();
        final SessionsCubit sessionsCubit = SessionsCubit(
          cacheManager: fortunicaGetIt.get<FortunicaCachingManager>(),
          connectivityService: fortunicaGetIt.get<ConnectivityService>(),
          chatsRepository: fortunicaGetIt.get<FortunicaChatsRepository>(),
          mainCubit: mainCubit,
        );

        _updateSessionsSubscription = mainCubit.sessionsUpdateTrigger.listen(
          (value) {
            sessionsCubit.getQuestions().then((value) => SchedulerBinding
                .instance.endOfFrame
                .then((value) => publicQuestionsScrollController.jumpTo(0.0)));
          },
        );

        publicQuestionsScrollController.addListener(() {
          if (!sessionsCubit.isPublicLoading &&
              publicQuestionsScrollController.position.extentAfter <=
                  screenHeight) {
            sessionsCubit.getPublicQuestions();
          }
        });
        conversationsScrollController.addListener(() {
          if (!sessionsCubit.isConversationsLoading &&
              conversationsScrollController.position.extentAfter <=
                  screenHeight) {
            sessionsCubit.getConversations();
          }
        });

        return sessionsCubit;
      },
      child: Builder(builder: (BuildContext context) {
        final SessionsCubit sessionsCubit = context.read<SessionsCubit>();

        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
        final UserStatus? userStatus =
            context.select((HomeCubit cubit) => cubit.state.userStatus);

        final bool statusIsLive =
            (userStatus?.status == FortunicaUserStatus.live) == true;

        return Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: isOnline
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).scaffoldBackgroundColor,
              appBar: HomeAppBar(
                bottomWidget: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding,
                  ),
                  child: Opacity(
                    opacity: isOnline && statusIsLive ? 1.0 : 0.4,
                    child: Builder(builder: (context) {
                      final List<int> disabledIndexes = context.select(
                          (SessionsCubit cubit) => cubit.state.disabledIndexes);
                      final int currentIndex = context.select(
                          (SessionsCubit cubit) =>
                              cubit.state.currentOptionIndex);

                      return Row(
                        children: [
                          Expanded(
                            child: ChooseOptionWidget(
                              options: [
                                SFortunica.of(context).publicFortunica,
                                SFortunica.of(context).privateFortunica,
                              ],
                              currentIndex: currentIndex,
                              disabledIndexes: disabledIndexes,
                              onChangeOptionIndex: isOnline && statusIsLive
                                  ? sessionsCubit.changeCurrentOptionIndex
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Opacity(
                            opacity: disabledIndexes.isEmpty ? 1.0 : 0.4,
                            child: AppIconButton(
                              icon: Assets.vectors.search.path,
                              onTap: isOnline &&
                                      statusIsLive &&
                                      disabledIndexes.isEmpty
                                  ? sessionsCubit.openSearch
                                  : null,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                withBrands: true,
              ),
              body: Builder(builder: (context) {
                if (isOnline) {
                  if (statusIsLive) {
                    return ListOfQuestions(
                      publicQuestionsScrollController:
                          publicQuestionsScrollController,
                      conversationsScrollController:
                          conversationsScrollController,
                    );
                  } else {
                    return NotLiveStatusWidget(
                      status: userStatus?.status ?? FortunicaUserStatus.offline,
                    );
                  }
                } else {
                  return const CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            NoConnectionWidget(),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
            Builder(builder: (context) {
              final bool searchIsOpen = context
                  .select((SessionsCubit cubit) => cubit.state.searchIsOpen);
              return isOnline && searchIsOpen
                  ? SearchListWidget(
                      closeOnTap: sessionsCubit.closeSearch,
                      marketsType: sessionsCubit.state.userMarkets[
                          sessionsCubit.state.currentMarketIndexForPrivate],
                    )
                  : const SizedBox.shrink();
            }),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    publicQuestionsScrollController.dispose();
    conversationsScrollController.dispose();
    _updateSessionsSubscription.cancel();
    super.dispose();
  }
}
