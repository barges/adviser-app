import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../infrastructure/routing/app_router.dart';
import '../../../data/cache/fortunica_caching_manager.dart';
import '../../../data/models/app_error/app_error.dart';
import '../../../data/models/chats/chat_item.dart';
import '../../../data/models/enums/zodiac_sign.dart';
import '../../../domain/repositories/fortunica_chats_repository.dart';
import '../../../domain/repositories/fortunica_customer_repository.dart';
import '../../../generated/l10n.dart';
import '../../../infrastructure/di/inject_config.dart';
import '../../../infrastructure/routing/app_router.gr.dart';
import '../../../main_cubit.dart';
import '../../../services/connectivity_service.dart';
import '../../common_widgets/appbar/chat_conversation_app_bar.dart';
import '../../common_widgets/messages/app_error_widget.dart';
import '../../common_widgets/no_connection_widget.dart';
import '../../common_widgets/ok_cancel_alert.dart';
import '../home/tabs_types.dart';
import 'customer_sessions_cubit.dart';
import 'widgets/customer_sessions_filters_widget.dart';
import 'widgets/customer_sessions_list_widget.dart';
import 'widgets/empty_customer_sessions_list_widget.dart';

class CustomerSessionsScreen extends StatelessWidget {
  final CustomerSessionsScreenArguments customerSessionsScreenArguments;

  const CustomerSessionsScreen({
    Key? key,
    required this.customerSessionsScreenArguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => CustomerSessionsCubit(
              chatsRepository: fortunicaGetIt.get<FortunicaChatsRepository>(),
              customerRepository:
                  fortunicaGetIt.get<FortunicaCustomerRepository>(),
              mainCubit: fortunicaGetIt.get<MainCubit>(),
              connectivityService: fortunicaGetIt.get<ConnectivityService>(),
              cacheManager: fortunicaGetIt.get<FortunicaCachingManager>(),
              screenHeight: MediaQuery.of(context).size.height,
              showErrorAlert: () => showErrorAlert(context),
              arguments: customerSessionsScreenArguments,
            ),
        child: Builder(builder: (context) {
          final CustomerSessionsCubit customerSessionsCubit =
              context.read<CustomerSessionsCubit>();
          final String? clientName = context
              .select((CustomerSessionsCubit cubit) => cubit.state.clientName);
          final ZodiacSign? zodiacSign = context
              .select((CustomerSessionsCubit cubit) => cubit.state.zodiacSign);
          return Scaffold(
              backgroundColor: Theme.of(context).canvasColor,
              appBar: ChatConversationAppBar(
                title: clientName,
                zodiacSign: zodiacSign,
              ),
              body: Builder(builder: (context) {
                final bool isOnline = context.select((MainCubit cubit) =>
                    cubit.state.internetConnectionIsAvailable);
                final AppError appError =
                    context.select((MainCubit cubit) => cubit.state.appError);
                return Column(
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    CustomerSessionsFiltersWidget(isOnline: isOnline),
                    const Divider(
                      height: 1,
                    ),
                    AppErrorWidget(
                      errorMessage: appError.getMessage(context),
                      close: customerSessionsCubit.closeErrorWidget,
                    ),
                    Expanded(
                      child: Builder(builder: (context) {
                        final List<ChatItem>? questions = context.select(
                            (CustomerSessionsCubit cubit) =>
                                cubit.state.privateQuestionsWithHistory);

                        if (!isOnline) {
                          return const CustomScrollView(slivers: [
                            SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    NoConnectionWidget(),
                                  ],
                                )),
                          ]);
                        } else {
                          if (questions == null) {
                            return RefreshIndicator(
                              onRefresh: customerSessionsCubit.getData,
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                  )
                                ],
                              ),
                            );
                          } else if (questions.isNotEmpty) {
                            return CustomerSessionsListWidget(
                                questions: questions);
                          } else {
                            return const EmptyCustomerSessionsListWidget();
                          }
                        }
                      }),
                    ),
                  ],
                );
              }));
        }));
  }

  showErrorAlert(BuildContext context) async {
    await showOkCancelAlert(
      context: context,
      title: fortunicaGetIt.get<MainCubit>().state.appError.getMessage(context),
      okText: SFortunica.of(context).okFortunica,
      actionOnOK: () async {
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

class CustomerSessionsScreenArguments {
  ChatItem question;
  int marketIndex;

  CustomerSessionsScreenArguments({
    required this.question,
    required this.marketIndex,
  });
}
