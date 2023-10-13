import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbars/simple_app_bar.dart';
import 'package:zodiac/data/models/canned_messages/canned_category.dart';
import 'package:zodiac/data/models/canned_messages/canned_message.dart';
import 'package:zodiac/generated/l10n.dart';

import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/canned_messages/widgets/add_canned_message_widget.dart';
import 'package:zodiac/presentation/screens/canned_messages/widgets/canned_message_manager_widget.dart';

const verticalInterval = 24.0;
const scrollPositionToShowMessages = 620.0;

class CannedMessagesScreen extends StatelessWidget {
  const CannedMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => zodiacGetIt.get<CannedMessagesCubit>(),
      child: Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).cannedMessagesZodiac,
        ),
        body: Builder(builder: (context) {
          final CannedMessagesCubit cannedMessagesCubit =
              context.read<CannedMessagesCubit>();

          final (
            List<CannedCategory>?,
            List<CannedMessage>?,
          ) record = context.select(
            (CannedMessagesCubit value) => (
              value.state.categories,
              value.state.messages,
            ),
          );
          final (
            List<CannedCategory>? categories,
            List<CannedMessage>? messages,
          ) = record;

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
                      padding: const EdgeInsets.only(
                          bottom: verticalInterval, top: 16.0),
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
                                CannedMessageManagerWidget(
                                    key: cannedMessagesCubit
                                        .cannedMessageManagerKey),
                              ],
                            ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}
