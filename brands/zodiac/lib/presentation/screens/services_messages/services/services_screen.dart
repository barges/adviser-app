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
  final ValueNotifier<int> indexNotifier = ValueNotifier(0);
  ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return BlocProvider(
      lazy: false,
      create: (context) => zodiacGetIt.get<ServicesCubit>(),
      child: Builder(builder: (context) {
        final ServicesCubit servicesCubit = context.read<ServicesCubit>();
        final List<ServiceItem>? services =
            context.select((ServicesCubit cubit) => cubit.state.services);
        if (services == null) {
          return const SizedBox.expand();
        } else {
          return RefreshIndicator(
            onRefresh: () {
              return servicesCubit.getServices();
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: verticalInterval),
                  child: ValueListenableBuilder(
                      valueListenable: indexNotifier,
                      builder: (_, int value, __) {
                        return ListOfFiltersWidget(
                          currentFilterIndex: value,
                          onTapToFilter: (index) {
                            if (index != null) {
                              indexNotifier.value = index;
                              servicesCubit
                                  .setStatus(index == 0 ? null : index - 1);
                              servicesCubit.getServices();
                            }
                          },
                          filters: [
                            SZodiac.of(context).allZodiac,
                            SZodiac.of(context).newZodiac,
                            SZodiac.of(context).approvedZodiac,
                            SZodiac.of(context).rejectedZodiac,
                            SZodiac.of(context).tempZodiac
                          ],
                          padding: AppConstants.horizontalScreenPadding,
                        );
                      }),
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
                    onPressed: () => context.push(
                      route: const ZodiacAddService(),
                    ),
                  ),
                )
              ],
            ),
          );
        }
      }),
    );
  }
}
