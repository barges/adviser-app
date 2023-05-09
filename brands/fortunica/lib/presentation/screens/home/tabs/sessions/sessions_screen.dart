import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:fortunica/data/models/user_info/user_status.dart';
import 'package:fortunica/domain/repositories/fortunica_chats_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/home_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:fortunica/presentation/common_widgets/buttons/choose_option_widget.dart';
import 'package:fortunica/presentation/common_widgets/no_connection_widget.dart';
import 'package:fortunica/presentation/screens/home/home_cubit.dart';
import 'package:fortunica/presentation/screens/home/tabs/sessions/sessions_cubit.dart';
import 'package:fortunica/presentation/screens/home/tabs/sessions/widgets/list_of_questions.dart';
import 'package:fortunica/presentation/screens/home/tabs/sessions/widgets/search/search_list_widget.dart';
import 'package:fortunica/presentation/screens/home/tabs/sessions/widgets/status_not_live_widget.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SessionsCubit(
        cacheManager: fortunicaGetIt.get<FortunicaCachingManager>(),
        connectivityService: fortunicaGetIt.get<ConnectivityService>(),
        chatsRepository: fortunicaGetIt.get<FortunicaChatsRepository>(),
        mainCubit: fortunicaGetIt.get<FortunicaMainCubit>(),
        screenHeight: MediaQuery.of(context).size.height,
      ),
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
                    return const ListOfQuestions();
                  } else {
                    return NotLiveStatusWidget(
                      status: userStatus?.status ?? FortunicaUserStatus.offline,
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
