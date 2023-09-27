import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/common_widgets/service/choose_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/tile_menu_button.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_state.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/information_expansion_panel.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/languages_part_widget.dart';
import 'package:zodiac/presentation/common_widgets/service/preview_part/service_preview_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/sliders_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/tabs_widget.dart';
import 'package:zodiac/zodiac_constants.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class AddServiceBodyWidget extends StatelessWidget {
  final List<ImageSampleModel> images;
  final List<String> languagesList;

  const AddServiceBodyWidget({
    Key? key,
    required this.images,
    required this.languagesList,
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
                      Builder(builder: (context) {
                        final ServiceType serviceType = context.select(
                            (AddServiceCubit cubit) => cubit.state.selectedTab);

                        final bool hasOfflineService = context.select(
                            (AddServiceCubit cubit) =>
                                cubit.state.hasOfflineService);
                        final bool hasOnlineService = context.select(
                            (AddServiceCubit cubit) =>
                                cubit.state.hasOnlineService);

                        if ((serviceType == ServiceType.offline &&
                                !hasOfflineService) ||
                            (serviceType == ServiceType.online &&
                                !hasOnlineService)) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: InformationExpansionPanel(
                              title: serviceType.getInformationTitle(context),
                              content:
                                  serviceType.getInformationContent(context),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      Builder(builder: (context) {
                        final bool hasApprovedServices = context.select(
                            (AddServiceCubit cubit) =>
                                cubit.state.hasApprovedServices);

                        if (hasApprovedServices) {
                          final String? duplicatedServiceName = context.select(
                              (AddServiceCubit cubit) =>
                                  cubit.state.duplicatedServiceName);

                          return Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: TileMenuButton(
                              label: SZodiac.of(context)
                                  .duplicateAnExistingServiceZodiac,
                              title: duplicatedServiceName,
                              onTap: () =>
                                  addServiceCubit.goToDuplicateService(context),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }),
                      const SizedBox(
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
                LanguagesPartWidget(
                  languagesList: languagesList,
                ),
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
                      Builder(builder: (context) {
                        final int selectedImageIndex = context.select(
                            (AddServiceCubit cubit) =>
                                cubit.state.selectedImageIndex);
                        final bool showAllImages = context.select(
                            (AddServiceCubit cubit) =>
                                cubit.state.showAllImages);

                        return ChooseImageWidget(
                          images: images,
                          selectImage: addServiceCubit.selectImage,
                          selectedImageIndex: selectedImageIndex,
                          showAllImages: showAllImages,
                          setShowAllImages: addServiceCubit.setShowAllImages,
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Builder(builder: (context) {
                  context.select((AddServiceCubit cubit) =>
                      cubit.state.updateAfterDuplicate);
                  context.select(
                      (AddServiceCubit cubit) => cubit.state.updateTextsFlag);

                  final ServicePreviewDto dto =
                      context.select((AddServiceCubit cubit) {
                    final AddServiceState state = cubit.state;

                    return (
                      selectedImage: images[state.selectedImageIndex],
                      titleController: addServiceCubit.textControllersMap[
                              state.languagesList?[state.selectedLanguageIndex]]
                          ?[ZodiacConstants.serviceTitleIndex],
                      descriptionController: addServiceCubit.textControllersMap[
                              state.languagesList?[state.selectedLanguageIndex]]
                          ?[ZodiacConstants.serviceDescriptionIndex],
                      price: state.price,
                      discount: state.discount,
                      discountEnabled: state.discountEnabled,
                      serviceType: state.selectedTab,
                      deliveryTime: state.deliveryTime,
                      deliveryTimeType: state.selectedDeliveryTimeTab,
                    );
                  });

                  return ServicePreviewPartWidget(
                    dto: dto,
                  );
                }),
                const SizedBox(
                  height: 24.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding,
                  ),
                  child: AppElevatedButton(
                    title: SZodiac.of(context).sendForApprovalZodiac,
                    onPressed: () async {
                      if (await addServiceCubit.sendForApproval(context)) {
                        // ignore: use_build_context_synchronously
                        context.read<ZodiacMainCubit>().updateServices();
                      }
                    },
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
