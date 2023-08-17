import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/something_went_wrong_widget.dart';
import 'package:zodiac/presentation/screens/edit_service/edit_service_cubit.dart';
import 'package:zodiac/presentation/screens/edit_service/widgets/edit_service_body_widget.dart';

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
        userRepository: zodiacGetIt.get<ZodiacUserRepository>(),
      ),
      child: Builder(builder: (context) {
        final EditServiceCubit editServiceCubit =
            context.read<EditServiceCubit>();

        return Scaffold(
          appBar: SimpleAppBar(
            title: SZodiac.of(context).editServiceZodiac,
          ),
          body: Builder(builder: (context) {
            final bool dataFetched = context
                .select((EditServiceCubit cubit) => cubit.state.dataFetched);

            if (dataFetched) {
              return const EditServiceBodyWidget();
            } else {
              final bool alreadyFetchData = context.select(
                  (EditServiceCubit cubit) => cubit.state.alreadyFetchData);

              if (alreadyFetchData) {
                return RefreshIndicator(
                  onRefresh: editServiceCubit.fetchData,
                  child: const CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: SomethingWentWrongWidget(),
                      )
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          }),
        );
      }),
    );
  }
}
