import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/list_of_questions.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/search/search_list_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/widgets/status_not_live_widget.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

class SessionsScreen extends StatelessWidget {
  final CachingManager cacheManager;
  final ConnectivityService connectivityService;
  final ChatsRepository chatsRepository;

  const SessionsScreen({
    Key? key,
    required this.cacheManager,
    required this.connectivityService,
    required this.chatsRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainCubit mainCubit = context.read<MainCubit>();
    return BlocProvider(
      create: (BuildContext context) => SessionsCubit(cacheManager, context,
          connectivityService, chatsRepository, mainCubit),
      child: Builder(builder: (BuildContext context) {
        final SessionsCubit sessionsCubit = context.read<SessionsCubit>();

        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
        final UserStatus userStatus =
            context.select((HomeCubit cubit) => cubit.state.userStatus);

        final bool statusIsLive = userStatus.status == FortunicaUserStatus.live;

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
                                S.of(context).public,
                                S.of(context).forMe,
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
                    return const ListOfQuestions();
                  } else {
                    return NotLiveStatusWidget(
                      status: userStatus.status ?? FortunicaUserStatus.offline,
                    );
                  }
                } else {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
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
}
