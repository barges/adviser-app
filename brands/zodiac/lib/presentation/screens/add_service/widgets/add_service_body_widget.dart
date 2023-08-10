import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/tile_menu_button.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/choose_image_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/information_expansion_panel.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/languages_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/preview_part/service_preview_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/sliders_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/tabs_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class AddServiceBodyWidget extends StatelessWidget {
  final List<ImageSampleModel> images;

  const AddServiceBodyWidget({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

    return Stack(
      children: [
        SingleChildScrollView(
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
                        title:
                            SZodiac.of(context).moreAboutOfflineServicesZodiac,
                        content: SZodiac.of(context)
                            .thisTypeOfServicesAreNotTimeSensitiveZodiac,
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Builder(builder: (context) {
                        final String? duplicatedServiceName = context.select(
                            (AddServiceCubit cubit) =>
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 24.0,
                      ),
                      const SlidersPartWidget(),
                      const SizedBox(
                        height: 24.0,
                      ),
                      ChooseImageWidget(
                        images: images,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                ServicePreviewPartWidget(
                  images: images,
                ),
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
