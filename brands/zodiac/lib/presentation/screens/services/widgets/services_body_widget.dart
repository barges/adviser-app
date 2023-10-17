import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/list_of_filters_widget.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/no_services_widget.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_screen.dart';
import 'package:zodiac/presentation/screens/services/services_cubit.dart';
import 'package:zodiac/presentation/screens/services/widgets/service_card.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ServicesBodyWidget extends StatelessWidget {
  final List<ServiceItem> services;

  const ServicesBodyWidget({Key? key, required this.services})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final ServicesCubit servicesCubit = context.read<ServicesCubit>();

    int selectedStatusIndex = context
        .select((ServicesCubit cubit) => cubit.state.selectedStatusIndex);

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () {
            return servicesCubit.getServices(refresh: true);
          },
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(bottom: verticalInterval, top: 16.0),
                child: ListOfFiltersWidget(
                  currentFilterIndex: selectedStatusIndex,
                  onTapToFilter: (index) {
                    servicesCubit.getServices(
                      index: index,
                    );
                  },
                  filters: [
                    SZodiac.of(context).allZodiac,
                    ...ServicesCubit.listOfFilters
                        .map((e) => e.getTitle(context))
                  ],
                  padding: AppConstants.horizontalScreenPadding,
                ),
              ),
              Expanded(
                child: servicesCubit.isDataServices
                    ? ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.horizontalScreenPadding),
                        itemBuilder: (_, index) =>
                            ServiceCard(serviceItem: services[index]),
                        separatorBuilder: (_, __) => const SizedBox(
                              height: AppConstants.horizontalScreenPadding,
                            ),
                        itemCount: services.length)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NoServicesWidget(),
                        ],
                      ),
              ),
              Container(
                decoration: BoxDecoration(color: theme.canvasColor),
                padding: const EdgeInsets.all(16.0),
                child: AppElevatedButton(
                  title: SZodiac.of(context).addServiceZodiac,
                  onPressed: () => servicesCubit.goToAddService(context),
                ),
              ),
            ],
          ),
        ),
        Builder(builder: (context) {
          final bool internetConnectionIsAvailable = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);

          if (internetConnectionIsAvailable) {
            final ZodiacMainCubit zodiacMainCubit =
                context.read<ZodiacMainCubit>();

            final AppError appError =
                context.select((ZodiacMainCubit cubit) => cubit.state.appError);

            return AppErrorWidget(
              errorMessage: appError.getMessage(context),
              close: zodiacMainCubit.clearErrorMessage,
            );
          } else {
            return AppErrorWidget(
                errorMessage: SZodiac.of(context).noInternetConnectionZodiac);
          }
        })
      ],
    );
  }
}
