import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/customer_sessions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/widgets/customer_sessions_filters_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/widgets/customer_sessions_list_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/customer_sessions/widgets/empty_customer_sessions_list_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs_types.dart';

class CustomerSessionsScreen extends StatelessWidget {
  const CustomerSessionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => CustomerSessionsCubit(
              getIt.get<CachingManager>(),
              MediaQuery.of(context).size.height,
              () => showErrorAlert(context),
            ),
        child: Builder(builder: (context) {
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
                return Column(
                  children: [
                    const Divider(
                      height: 1,
                    ),
                    CustomerSessionsFiltersWidget(isOnline: isOnline),
                    const Divider(
                      height: 1,
                    ),
                    Expanded(
                      child: Builder(builder: (context) {
                        final List<ChatItem>? questions = context.select(
                            (CustomerSessionsCubit cubit) =>
                                cubit.state.privateQuestionsWithHistory);

                        if (!isOnline) {
                          return CustomScrollView(slivers: [
                            SliverFillRemaining(
                                hasScrollBody: false,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    NoConnectionWidget(),
                                  ],
                                )),
                          ]);
                        } else {
                          if (questions == null) {
                            return const SizedBox.shrink();
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
