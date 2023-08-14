import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/screens/edit_service/edit_service_cubit.dart';

class EditServiceScreen extends StatelessWidget {
  final int serviceId;

  const EditServiceScreen({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (_) => EditServiceCubit(
        serviceId: serviceId,
        servicesRepository: zodiacGetIt.get<ZodiacServicesRepository>(),
      ),
      child: Builder(builder: (context) {
        final EditServiceCubit editServiceCubit =
            context.read<EditServiceCubit>();
        return Scaffold(
          appBar: SimpleAppBar(
            title: SZodiac.of(context).editServiceZodiac,
          ),
          body: Column(), //CustomScrollView(),
        );
      }),
    );
  }
}
