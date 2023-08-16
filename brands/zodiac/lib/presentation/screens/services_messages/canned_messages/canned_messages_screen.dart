import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';

import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';

import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/add_canned_message_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/canned_message_manager_widget.dart';

const verticalInterval = 24.0;
const scrollPositionToShowMessages = 620.0;

class CannedMessagesScreen extends StatefulWidget {
  const CannedMessagesScreen({super.key});

  @override
  State<CannedMessagesScreen> createState() => _CannedMessagesScreenState();
}

class _CannedMessagesScreenState extends State<CannedMessagesScreen> {
  final ScrollController controller = ScrollController();
  int? messagesCount;
  int selectedCategoryIndex = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => zodiacGetIt.get<CannedMessagesCubit>(),
      child: Builder(builder: (context) {
        final CannedMessagesCubit cannedMessagesCubit =
            context.read<CannedMessagesCubit>();
        final categories = context
            .select((CannedMessagesCubit cubit) => cubit.state.categories);
        final messages =
            context.select((CannedMessagesCubit cubit) => cubit.state.messages);
        if (selectedCategoryIndex !=
                cannedMessagesCubit.state.selectedCategoryIndex &&
            messagesCount != messages?.length) {
          if (messagesCount != null && messagesCount! < messages!.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.animateTo(
                  controller.position.maxScrollExtent >
                          scrollPositionToShowMessages
                      ? scrollPositionToShowMessages
                      : controller.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            });
          }
          selectedCategoryIndex =
              cannedMessagesCubit.state.selectedCategoryIndex;
          messagesCount = messages?.length;
        }
        final bool isNoData = categories == null || messages == null;
        final bool showErrorData = context
            .select((CannedMessagesCubit cubit) => cubit.state.showErrorData);
        return RefreshIndicator(
          onRefresh: () {
            return cannedMessagesCubit.loadData();
          },
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: isNoData && !showErrorData
                ? const SizedBox.shrink()
                : SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.only(bottom: verticalInterval),
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: showErrorData
                        ? Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height -
                                AppConstants.appBarHeight -
                                AppConstants.horizontalScreenPadding -
                                38.0 * 2 -
                                verticalInterval * 2,
                            child: const SomethingWentWrongWidget())
                        : const Column(
                            children: [
                              AddCannedMessageWidget(),
                              CannedMessageManagerWidget(),
                            ],
                          ),
                  ),
          ),
        );
      }),
    );
  }
}
