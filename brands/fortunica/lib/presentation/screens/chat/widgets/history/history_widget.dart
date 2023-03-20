import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/models/chats/history_ui_model.dart';
import 'package:fortunica/domain/repositories/fortunica_chats_repository.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:fortunica/presentation/screens/chat/chat_cubit.dart';
import 'package:fortunica/presentation/screens/chat/widgets/history/history_cubit.dart';
import 'package:fortunica/presentation/screens/chat/widgets/history/widgets/empty_history_list_widget.dart';
import 'package:fortunica/presentation/screens/chat/widgets/history/widgets/history_list_started_from_begin_widget.dart';
import 'package:fortunica/presentation/screens/chat/widgets/history/widgets/history_list_started_with_story_id.dart';
import 'package:fortunica/presentation/screens/home/tabs_types.dart';

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
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return BlocProvider(
      create: (_) => HistoryCubit(
        fortunicaGetIt.get<FortunicaChatsRepository>(),
        fortunicaGetIt.get<ConnectivityService>(),
        () => showErrorAlert(context),
        clientId,
        storyId,
        chatCubit,
      ),
      child: Builder(builder: (context) {
        if (storyId != null) {
          final List<HistoryUiModel>? bottomHistoriesList = context
              .select((HistoryCubit cubit) => cubit.state.bottomHistoriesList);

          if (bottomHistoriesList == null) {
            return RefreshIndicator(
              onRefresh: chatCubit.refreshChatInfo,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: MediaQuery.of(context).size.height,
                  )
                ],
              ),
            );
          }
          if (bottomHistoriesList.isEmpty) {
            return const EmptyHistoryListWidget();
          }

          return HistoryListStartedWithStoryIdWidget(
            bottomHistoriesList: bottomHistoriesList,
          );
        } else {
          final List<HistoryUiModel>? bottomHistoriesList = context
              .select((HistoryCubit cubit) => cubit.state.bottomHistoriesList);

          if (bottomHistoriesList == null) {
            return RefreshIndicator(
              onRefresh: chatCubit.refreshChatInfo,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: MediaQuery.of(context).size.height,
                  )
                ],
              ),
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

  showErrorAlert(BuildContext context) async {
    await showOkCancelAlert(
      context: context,
      title: fortunicaGetIt
          .get<FortunicaMainCubit>()
          .state
          .appError
          .getMessage(context),
      okText: SFortunica.of(context).okFortunica,
      actionOnOK: () {
        context.replaceAll([
          FortunicaHome(
            initTab: TabsTypes.sessions,
          )
        ]);
      },
      allowBarrierClick: false,
      isCancelEnabled: false,
    );
  }
}
