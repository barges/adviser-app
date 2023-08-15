import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/service/preview_part/service_preview_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';

class ServicePreviewPartWidget extends StatelessWidget {
  final ImageSampleModel selectedImage;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final double price;
  final double discount;
  final bool discountEnabled;
  final ServiceType serviceType;
  final double deliveryTime;
  final DeliveryTimeTabType deliveryTimeType;

  const ServicePreviewPartWidget({
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

    return Column(
      children: [
        Text(
          SZodiac.of(context).servicePreviewZodiac,
          style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
        ),
        const SizedBox(
          height: 12.0,
        ),
        DottedBorder(
          color: theme.shadowColor,
          borderType: BorderType.RRect,
          radius: const Radius.circular(32.0),
          padding: const EdgeInsets.all(24.0),
          strokeWidth: 2.0,
          dashPattern: const [8.0, 8.0],
          child: ServicePreviewWidget(
            selectedImage: selectedImage,
            titleController: titleController,
            descriptionController: descriptionController,
            price: price,
            discount: discount,
            discountEnabled: discountEnabled,
            serviceType: serviceType,
            deliveryTime: deliveryTime,
            deliveryTimeType: deliveryTimeType,
          ),
        ),
      ],
    );
  }
}
