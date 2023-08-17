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
import 'package:zodiac/presentation/common_widgets/service/discount_for_reorder_slider_widget.dart';
import 'package:zodiac/presentation/common_widgets/service/preview_part/service_preview_part_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';
import 'package:zodiac/presentation/screens/edit_service/edit_service_cubit.dart';
import 'package:zodiac/presentation/screens/edit_service/widgets/languages_part_widget.dart';
import 'package:zodiac/zodiac_constants.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class EditServiceBodyWidget extends StatelessWidget {
  const EditServiceBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EditServiceCubit editServiceCubit = context.read<EditServiceCubit>();

    return Stack(
      children: [
        GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Builder(builder: (context) {
                    List<String>? languagesList = context.select(
                        (EditServiceCubit cubit) => cubit.state.languagesList);
                    if (languagesList != null) {
                      return LanguagesPartWidget(
                        languagesList: languagesList,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding),
                    child: Column(
                      children: [
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
                            onDiscountChanged:
                                editServiceCubit.onDiscountChanged,
                            onDiscountEnabledChanged:
                                editServiceCubit.onDiscountEnabledChanged,
                          );
                        }),
                        const SizedBox(
                          height: 24.0,
                        ),
                        Builder(builder: (context) {
                          final List<ImageSampleModel>? images = context.select(
                              (EditServiceCubit cubit) => cubit.state.images);
                          final int selectedImageIndex = context.select(
                              (EditServiceCubit cubit) =>
                                  cubit.state.selectedImageIndex);
                          final bool showAllImages = context.select(
                              (EditServiceCubit cubit) =>
                                  cubit.state.showAllImages);

                          if (images != null) {
                            return ChooseImageWidget(
                              images: images,
                              selectedImageIndex: selectedImageIndex,
                              showAllImages: showAllImages,
                              selectImage: editServiceCubit.selectImage,
                              setShowAllImages:
                                  editServiceCubit.setShowAllImages,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Builder(builder: (context) {
                    final List<ImageSampleModel>? images = context
                        .select((EditServiceCubit cubit) => cubit.state.images);
                    final int selectedImageIndex = context.select(
                        (EditServiceCubit cubit) =>
                            cubit.state.selectedImageIndex);
                    final int selectedLanguageIndex = context.select(
                        (EditServiceCubit cubit) =>
                            cubit.state.selectedLanguageIndex);

                    final double price = context
                        .select((EditServiceCubit cubit) => cubit.state.price);
                    final double discount = context.select(
                        (EditServiceCubit cubit) => cubit.state.discount);
                    final bool discountEnabled = context.select(
                        (EditServiceCubit cubit) =>
                            cubit.state.discountEnabled);
                    final ServiceType serviceType = context.select(
                        (EditServiceCubit cubit) => cubit.state.serviceType);

                    final double deliveryTime = context.select(
                        (EditServiceCubit cubit) => cubit.state.deliveryTime);
                    final DeliveryTimeTabType deliveryTimeType = context.select(
                        (EditServiceCubit cubit) =>
                            cubit.state.deliveryTimeType);

                    return ServicePreviewPartWidget(
                        selectedImage: images?[selectedImageIndex] ??
                            const ImageSampleModel(),
                        titleController: editServiceCubit
                            .textControllersMap.entries
                            .toList()[selectedLanguageIndex]
                            .value[ZodiacConstants.serviceTitleIndex],
                        descriptionController: editServiceCubit
                            .textControllersMap.entries
                            .toList()[selectedLanguageIndex]
                            .value[ZodiacConstants.serviceDescriptionIndex],
                        price: price,
                        discount: discount,
                        discountEnabled: discountEnabled,
                        serviceType: serviceType,
                        deliveryTime: deliveryTime,
                        deliveryTimeType: deliveryTimeType);
                  }),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Builder(builder: (context) {
                    final bool internetConnectionIsAvailable = context.select(
                        (MainCubit cubit) =>
                            cubit.state.internetConnectionIsAvailable);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.horizontalScreenPadding),
                      child: Opacity(
                        opacity: internetConnectionIsAvailable ? 1.0 : 0.8,
                        child: AppElevatedButton(
                          title: SZodiac.of(context).sendForApprovalZodiac,
                          onPressed: internetConnectionIsAvailable
                              ? () => editServiceCubit.sendForApproval(context)
                              : null,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 24.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        Builder(builder: (context) {
          final bool internetConnectionIsAvailable = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
          if (internetConnectionIsAvailable) {
            final AppError appError =
                context.select((ZodiacMainCubit cubit) => cubit.state.appError);
            return AppErrorWidget(
              errorMessage: appError.getMessage(context),
              close: context.read<ZodiacMainCubit>().clearErrorMessage,
            );
          } else {
            return AppErrorWidget(
              errorMessage: SZodiac.of(context).noInternetConnectionZodiac,
            );
          }
        })
      ],
    );
  }
}
