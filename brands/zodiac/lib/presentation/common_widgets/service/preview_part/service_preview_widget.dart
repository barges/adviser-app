import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/service/preview_part/service_preview_image_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';

class ServicePreviewWidget extends StatelessWidget {
  final ImageSampleModel selectedImage;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final double price;
  final double discount;
  final bool discountEnabled;
  final ServiceType serviceType;
  final double deliveryTime;
  final DeliveryTimeTabType deliveryTimeType;

  const ServicePreviewWidget({
    Key? key,
    required this.selectedImage,
    required this.titleController,
    required this.descriptionController,
    required this.price,
    required this.discount,
    required this.discountEnabled,
    required this.serviceType,
    required this.deliveryTime,
    required this.deliveryTimeType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 260.0,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: theme.canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ServicePreviewImageWidget(
            selectedImage: selectedImage,
            titleController: titleController,
            serviceType: serviceType,
            deliveryTime: deliveryTime,
            deliveryTimeType: deliveryTimeType,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: descriptionController,
                  builder: (context, value, child) => Text(
                    descriptionController.text,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14.0,
                      color: theme.shadowColor,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.zodiac.vectors.narrowServicesIcon.svg(
                        height: AppConstants.iconSize,
                        width: AppConstants.iconSize,
                        colorFilter: ColorFilter.mode(
                          theme.canvasColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '${SZodiac.of(context).buyZodiac}'
                        ' \$${(price * (discountEnabled ? (1 - discount / 100) : 1)).toStringAsFixed(2)}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 17.0,
                          color: theme.canvasColor,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
