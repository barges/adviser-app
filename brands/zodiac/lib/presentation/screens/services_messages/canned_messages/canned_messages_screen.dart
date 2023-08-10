import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';

import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';

import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/add_canned_message_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/widgets/canned_message_manager_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/services_messages_screen.dart';

class CannedMessagesScreen extends StatelessWidget {
  const CannedMessagesScreen({super.key});

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
                        : Column(
                            children: [
                              const AddCannedMessageWidget(),
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
