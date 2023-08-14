import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/service/discount_for_reorder_slider_widget.dart';
import 'package:zodiac/presentation/screens/edit_service/edit_service_cubit.dart';
import 'package:zodiac/presentation/screens/edit_service/widgets/languages_part_widget.dart';

class EditServiceScreen extends StatelessWidget {
  final int serviceId;

  const EditServiceScreen({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditServiceCubit(
        serviceId: serviceId,
        servicesRepository: zodiacGetIt.get<ZodiacServicesRepository>(),
        zodiacCachingManager: zodiacGetIt.get<ZodiacCachingManager>(),
      ),
      child: Builder(builder: (context) {
        final EditServiceCubit editServiceCubit =
            context.read<EditServiceCubit>();

        return Scaffold(
          appBar: SimpleAppBar(
            title: SZodiac.of(context).editServiceZodiac,
          ),
          body: Builder(builder: (context) {
            List<String>? languagesList = context
                .select((EditServiceCubit cubit) => cubit.state.languagesList);
            if (languagesList != null) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      LanguagesPartWidget(
                        languagesList: languagesList,
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Builder(builder: (context) {
                        final bool discountEnabled = context.select(
                            (EditServiceCubit cubit) =>
                                cubit.state.discountEnabled);
                        final double price = context.select(
                            (EditServiceCubit cubit) => cubit.state.price);
                        final double discount = context.select(
                            (EditServiceCubit cubit) => cubit.state.discount);
                        return DiscountForReorderWidget(
                          discountEnabled: discountEnabled,
                          price: price,
                          discount: discount,
                          onDiscountChanged: editServiceCubit.onDiscountChanged,
                          onDiscountEnabledChanged:
                              editServiceCubit.onDiscountEnabledChanged,
                        );
                      }),
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        );
      }),
    );
  }
}
