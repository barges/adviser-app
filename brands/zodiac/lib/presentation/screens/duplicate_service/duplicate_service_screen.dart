import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/data/models/services/service_item.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_tile_widget.dart';
import 'package:zodiac/presentation/common_widgets/search_widget.dart';
import 'package:zodiac/presentation/screens/duplicate_service/duplicate_service_cubit.dart';

class DuplicateServiceScreen extends StatelessWidget {
  const DuplicateServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DuplicateServiceCubit(),
      child: Builder(builder: (context) {
        final DuplicateServiceCubit duplicateServiceCubit =
            context.read<DuplicateServiceCubit>();

        final int? selectedDuplicatedService = context.select(
            (DuplicateServiceCubit cubit) =>
                cubit.state.selectedDuplicatedService);

        final List<ServiceItem>? services = context
            .select((DuplicateServiceCubit cubit) => cubit.state.services);

        return Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: WideAppBar(
            bottomWidget: Text(
              SZodiac.of(context).duplicateAnExistingServiceZodiac,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            topRightWidget: selectedDuplicatedService != null
                ? AppIconButton(
                    icon: Assets.vectors.check.path,
                    onTap: () {
                      context.pop();
                    },
                  )
                : null,
          ),
          body: Column(
            children: [
              SearchWidget(
                onChanged: duplicateServiceCubit.search,
              ),
              Expanded(child: Builder(
                builder: (context) {
                  if (services != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.horizontalScreenPadding),
                      child: ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) => CheckboxTileWidget(
                          isMultiselect: false,
                          isSelected: index == selectedDuplicatedService,
                          title: services[index].name ?? '',
                          onTap: () => duplicateServiceCubit
                              .selectDuplicatedService(index),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ))
            ],
          ),
        );
      }),
    );
  }
}
