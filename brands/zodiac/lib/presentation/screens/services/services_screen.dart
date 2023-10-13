import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbars/simple_app_bar.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/no_connection_widget.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';
import 'package:zodiac/presentation/screens/services/services_cubit.dart';
import 'package:zodiac/presentation/screens/services/widgets/services_body_widget.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => zodiacGetIt.get<ServicesCubit>(),
      child: Scaffold(
        appBar: SimpleAppBar(
          title: SZodiac.of(context).servicesZodiac,
        ),
        body: Builder(builder: (context) {
          final (List<ServiceItem>?, bool) record = context.select(
            (ServicesCubit cubit) =>
                (cubit.state.services, cubit.state.alreadyTriedToFetchData),
          );

          final (List<ServiceItem>? services, bool alreadyTriedToFetchData) =
              record;

          if (services != null) {
            return ServicesBodyWidget(
              services: services,
            );
          } else {
            if (alreadyTriedToFetchData) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<ServicesCubit>().getServices(refresh: true),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics()
                      .applyTo(const ClampingScrollPhysics()),
                  slivers: const [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: SomethingWentWrongWidget(),
                    )
                  ],
                ),
              );
            } else {
              final bool isOnline = context.select((MainCubit cubit) =>
                  cubit.state.internetConnectionIsAvailable);
              if (isOnline) {
                return const SizedBox.expand();
              } else {
                return const CustomScrollView(slivers: [
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NoConnectionWidget(),
                        ],
                      )),
                ]);
              }
            }
          }

          ////////////
        }),
      ),
    );
  }
}
