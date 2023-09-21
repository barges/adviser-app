import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/enums/service_status.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/no_services_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/list_of_filters_widget.dart';
import 'package:zodiac/presentation/screens/services_messages/services/services_cubit.dart';
import 'package:zodiac/presentation/screens/services_messages/services/widgets/service_card.dart';
import 'package:zodiac/presentation/screens/services_messages/services_messages_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider(
      lazy: false,
      create: (context) => zodiacGetIt.get<ServicesCubit>(),
      child: Builder(builder: (context) {
        final ServicesCubit servicesCubit = context.read<ServicesCubit>();

        final (
          List<ServiceItem>?,
          int?,
        ) record = context.select(
          (ServicesCubit value) => (
            value.state.services,
            value.state.selectedStatusIndex,
          ),
        );
        final (
          List<ServiceItem>? services,
          int? selectedStatusIndex,
        ) = record;

        if (services == null) {
          return const SizedBox.expand();
        } else {
          return RefreshIndicator(
            onRefresh: () {
              return servicesCubit.getServices(refresh: true);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: verticalInterval),
                  child: ListOfFiltersWidget(
                    currentFilterIndex: selectedStatusIndex == null
                        ? 0
                        : selectedStatusIndex + 1,
                    onTapToFilter: (index) {
                      if (index != null) {
                        servicesCubit.getServices(
                            status: index == 0 ? null : index - 1);
                      }
                    },
                    filters: [
                      SZodiac.of(context).allZodiac,
                      ServiceStatus.pending.getTitle(context),
                      ServiceStatus.approved.getTitle(context),
                      ServiceStatus.rejected.getTitle(context),
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
          );
        }
      }),
    );
  }
}
