import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/chats/history_ui_model.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/empty_history_list_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/history_list_started_from_begin_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/widgets/history_list_started_with_story_id.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

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
        getIt.get<ConnectivityService>(),
            () => showErrorAlert(context),
        clientId,
        storyId,
      ),
      child: Builder(builder: (context) {
        if (storyId != null) {
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

          return HistoryListStartedWithStoryIdWidget(
            bottomHistoriesList: bottomHistoriesList,
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

  showErrorAlert(BuildContext context) async {
    await showOkCancelAlert(
      context: context,
      title: getIt.get<MainCubit>().state.appError.getMessage(context),
      okText: S.of(context).ok,
      actionOnOK: () {
        Get.offNamedUntil(
            AppRoutes.home,
            arguments: HomeScreenArguments(
              initTab: TabsTypes.sessions,
            ),
                (route) => false);
      },
      allowBarrierClick: false,
      isCancelEnabled: false,
    );
  }
}
