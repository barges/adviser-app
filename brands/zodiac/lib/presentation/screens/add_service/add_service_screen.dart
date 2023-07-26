import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/domain/repositories/zodiac_sevices_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/common_widgets/tile_menu_button.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/choose_image_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/information_expansion_panel.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/languages_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/preview_part/service_preview_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/sliders_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/tabs_widget.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AddServiceCubit(
        zodiacGetIt.get<ZodiacCachingManager>(),
        zodiacGetIt.get<ZodiacServicesRepository>(),
      ),
      child: Builder(builder: (context) {
        final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

        return GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: SimpleAppBar(
              title: SZodiac.of(context).addServiceZodiac,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding,
                      ),
                      child: Column(
                        children: [
                          const TabsWidget(),
                          const SizedBox(
                            height: 24.0,
                          ),
                          InformationExpansionPanel(
                            title: SZodiac.of(context)
                                .moreAboutOfflineServicesZodiac,
                            content: SZodiac.of(context)
                                .thisTypeOfServicesAreNotTimeSensitiveZodiac,
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Builder(builder: (context) {
                            final String? duplicatedServiceName =
                                context.select((AddServiceCubit cubit) =>
                                    cubit.state.duplicatedServiceName);

                            return TileMenuButton(
                              label: SZodiac.of(context)
                                  .duplicateAnExistingServiceZodiac,
                              title: duplicatedServiceName,
                              onTap: () =>
                                  addServiceCubit.goToDuplicateService(context),
                            );
                          }),
                          const SizedBox(
                            height: 24.0,
                          ),
                        ],
                      ),
                    ),
                    const LanguagesPartWidget(),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding,
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 24.0,
                          ),
                          SlidersPartWidget(),
                          SizedBox(
                            height: 24.0,
                          ),
                          ChooseImageWidget(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    const ServicePreviewPartWidget(),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding,
                      ),
                      child: AppElevatedButton(
                        title: SZodiac.of(context).sendForApprovalZodiac,
                        onPressed: addServiceCubit.sendForApproval,
                      ),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
