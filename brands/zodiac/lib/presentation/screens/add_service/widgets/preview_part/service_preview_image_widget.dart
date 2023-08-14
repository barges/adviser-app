import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';
import 'package:zodiac/zodiac_constants.dart';

class ServicePreviewImageWidget extends StatelessWidget {
  final int selectedLanguageIndex;
  final List<ImageSampleModel> images;

  const ServicePreviewImageWidget({
    Key? key,
    required this.selectedLanguageIndex,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

    final int selectedImageIndex = context
        .select((AddServiceCubit cubit) => cubit.state.selectedImageIndex);

    final TextEditingController titleController = addServiceCubit
        .textControllersMap.entries
        .toList()[selectedLanguageIndex]
        .value[ZodiacConstants.serviceTitleIndex];

    return Stack(
      children: [
        AppImageWidget(
          uri: Uri.parse(images[selectedImageIndex].image ?? ''),
          height: 98.0,
          width: 260,
        ),
        Positioned(
          top: 16.0,
          right: 16.0,
          left: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: titleController,
                  builder: (context, value, child) => Text(
                    titleController.text,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 14.0,
                      color: theme.canvasColor,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
              const SizedBox(
                width: 32.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.promotion,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 6.0,
                ),
                child: Text(
                  SZodiac.of(context).newZodiac.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 12.0,
                    color: theme.canvasColor,
                  ),
                ),
              )
            ],
          ),
        ),
        const Positioned(
          bottom: 16.0,
          left: 16.0,
          child: _ServiceTypeAndDeliveryTimeWidget(),
        )
      ],
    );
  }
}

class _ServiceTypeAndDeliveryTimeWidget extends StatelessWidget {
  const _ServiceTypeAndDeliveryTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final ServiceType selectedTab =
        context.select((AddServiceCubit cubit) => cubit.state.selectedTab);

    final double deliveryTime =
        context.select((AddServiceCubit cubit) => cubit.state.deliveryTime);
    final DeliveryTimeTabType selectedDeliveryTimeTab = context
        .select((AddServiceCubit cubit) => cubit.state.selectedDeliveryTimeTab);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        '${selectedTab.getShortTitle(context)}:'
                ' ${selectedDeliveryTimeTab.formatter(
          context,
          deliveryTime.toStringAsFixed(0),
        )}'
            .toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 12.0,
          color: theme.primaryColor,
        ),
      ),
    );
  }
}
