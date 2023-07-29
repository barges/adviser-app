import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
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
        final List<ServiceItem>? services =
            context.select((ServicesCubit cubit) => cubit.state.services);
        if (services == null) {
          return const SizedBox.expand();
        } else {
          return Column(
            children: [
              if (services.isNotEmpty)
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: verticalInterval),
                        child: ListOfFiltersWidget(
                          currentFilterIndex: 0,
                          onTapToFilter: (index) {
                            if (index != null) {
                              /*indexNotifier.value = index;
                                              cannedMessagesCubit
                                                  .setCategory(index == 0 ? null : index - 1);
                                              cannedMessagesCubit
                                                  .filterCannedMessagesByCategory();*/
                            }
                          },
                          filters: [
                            SZodiac.of(context).allZodiac,
                            "Approved",
                            "Pending",
                            "Rejected"
                          ],
                          padding: AppConstants.horizontalScreenPadding,
                        ),
                      ),
                      Expanded(
                          child: ListView.separated(
                              //controller: articlesCubit.articlesScrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      AppConstants.horizontalScreenPadding),
                              itemBuilder: (_, index) =>
                                  ServiceCard(serviceItem: services[index]),
                              separatorBuilder: (_, __) => const SizedBox(
                                    height:
                                        AppConstants.horizontalScreenPadding,
                                  ),
                              itemCount: services.length)),
                    ],
                  ),
                ),
              if (services.isEmpty)
                const Expanded(
                  child: Column(
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
                  onPressed: () => context.push(
                    route: const ZodiacAddService(),
                  ),
                ),
              )
            ],
          );
        }
      }),
    );
  }
}
