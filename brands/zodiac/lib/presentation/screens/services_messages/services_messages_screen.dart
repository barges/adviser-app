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
import 'package:zodiac/zodiac_main_cubit.dart';

class ServicesMessagesScreen extends StatelessWidget {
  const ServicesMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ZodiacMainCubit zodiacMainCubit = context.read<ZodiacMainCubit>();
    int currentIndex = 1;
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
                        final bool isOnline = context.select(
                            (MainCubit cubit) =>
                                cubit.state.internetConnectionIsAvailable);
                        return AppErrorWidget(
                          errorMessage: !isOnline
                              ? SZodiac.of(context).noInternetConnectionZodiac
                              : appError.getMessage(context),
                          close: isOnline
                              ? zodiacMainCubit.clearErrorMessage
                              : null,
                        );
                      }),
                      Expanded(
                        child: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: AppConstants.horizontalScreenPadding,
                                    left: AppConstants.horizontalScreenPadding,
                                    right:
                                        AppConstants.horizontalScreenPadding),
                                child: ListOfFiltersWidget(
                                  currentFilterIndex: currentIndex,
                                  onTapToFilter: (index) {
                                    if (index != null) {
                                      setState(() => currentIndex = index);
                                    }
                                  },
                                  filters: [
                                    SZodiac.of(context).servicesZodiac,
                                    SZodiac.of(context).cannedMessagesZodiac
                                  ],
                                  itemWidth: (MediaQuery.of(context)
                                              .size
                                              .width -
                                          AppConstants.horizontalScreenPadding *
                                              2 -
                                          8.0) *
                                      0.5,
                                ),
                              ),
                              const SizedBox(height: verticalInterval),
                              Flexible(
                                child: IndexedStack(
                                  index: currentIndex,
                                  children: const [
                                    SizedBox.shrink(),
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
