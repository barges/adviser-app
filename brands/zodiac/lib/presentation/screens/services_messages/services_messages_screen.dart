import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/list_of_filters_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_screen.dart';
import 'package:zodiac/presentation/screens/services_messages/services/services_screen.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

const verticalInterval = 24.0;

class ServicesMessagesScreen extends StatelessWidget {
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);
  ServicesMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ZodiacMainCubit zodiacMainCubit = context.read<ZodiacMainCubit>();
    return Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).servicesMessagesZodiac,
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Builder(builder: (context) {
            final bool isOnline = context.select(
                (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
            return isOnline
                ? Column(
                    children: [
                      Builder(builder: (context) {
                        final AppError appError = context.select(
                            (ZodiacMainCubit cubit) => cubit.state.appError);
                        return AppErrorWidget(
                          errorMessage: appError.getMessage(context),
                          close: zodiacMainCubit.clearErrorMessage,
                        );
                      }),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: _indexNotifier,
                            builder: (BuildContext context, int value, _) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: AppConstants
                                            .horizontalScreenPadding,
                                        left: AppConstants
                                            .horizontalScreenPadding,
                                        right: AppConstants
                                            .horizontalScreenPadding),
                                    child: ListOfFiltersWidget(
                                      currentFilterIndex: value,
                                      onTapToFilter: (index) {
                                        if (index != null) {
                                          _indexNotifier.value = index;
                                        }
                                      },
                                      filters: [
                                        SZodiac.of(context).servicesZodiac,
                                        SZodiac.of(context)
                                            .cannedMessagesZodiac,
                                      ],
                                      itemWidth: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              AppConstants
                                                      .horizontalScreenPadding *
                                                  2 -
                                              8.0) /
                                          2,
                                    ),
                                  ),
                                  const SizedBox(height: verticalInterval),
                                  Flexible(
                                    child: IndexedStack(
                                      index: value,
                                      children: const [
                                        ServicesScreen(),
                                        CannedMessagesScreen(),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NoConnectionWidget(),
                    ],
                  );
          }),
        ));
  }
}
