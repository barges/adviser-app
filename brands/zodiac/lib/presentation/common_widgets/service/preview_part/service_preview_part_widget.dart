import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/data/models/enums/service_type.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/service/preview_part/service_preview_widget.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/sliders_part/delivery_time_slider_widget.dart';

typedef ServicePreviewDto = ({
  ImageSampleModel? selectedImage,
  TextEditingController? titleController,
  TextEditingController? descriptionController,
  double price,
  ServiceType serviceType,
  double deliveryTime,
  DeliveryTimeTabType deliveryTimeType,
});

class ServicePreviewPartWidget extends StatelessWidget {
  final ServicePreviewDto dto;

  const ServicePreviewPartWidget({
    Key? key,
    required this.dto,
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
            dto: dto,
          ),
        ),
      ],
    );
  }
}
