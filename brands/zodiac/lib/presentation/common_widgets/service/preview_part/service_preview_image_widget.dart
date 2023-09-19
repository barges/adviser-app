import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/app_image_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';

class ServicePreviewImageWidget extends StatelessWidget {
  final ImageSampleModel selectedImage;
  final TextEditingController titleController;
  final ServiceType serviceType;
  final double deliveryTime;
  final DeliveryTimeTabType deliveryTimeType;

  const ServicePreviewImageWidget({
    Key? key,
    required this.selectedImage,
    required this.titleController,
    required this.serviceType,
    required this.deliveryTime,
    required this.deliveryTimeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: [
        AppImageWidget(
          uri: Uri.parse(selectedImage.image ?? ''),
          height: 108.0,
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
                  vertical: 2.0,
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
        Positioned(
          bottom: 16.0,
          left: 16.0,
          child: _ServiceTypeAndDeliveryTimeWidget(
            serviceType: serviceType,
            deliveryTime: deliveryTime,
            deliveryTimeType: deliveryTimeType,
          ),
        )
      ],
    );
  }
}

class _ServiceTypeAndDeliveryTimeWidget extends StatelessWidget {
  final ServiceType serviceType;
  final double deliveryTime;
  final DeliveryTimeTabType deliveryTimeType;

  const _ServiceTypeAndDeliveryTimeWidget({
    Key? key,
    required this.serviceType,
    required this.deliveryTime,
    required this.deliveryTimeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
        '${serviceType.getShortTitle(context)}:'
                ' ${deliveryTimeType.formatter(
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
