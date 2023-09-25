import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/service/preview_part/service_preview_image_widget.dart';
import 'package:zodiac/presentation/common_widgets/service/preview_part/service_preview_part_widget.dart';

class ServicePreviewWidget extends StatelessWidget {
  final ServicePreviewDto dto;

  const ServicePreviewWidget({
    Key? key,
    required this.dto,
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
            selectedImage: dto.selectedImage,
            titleController: dto.titleController,
            serviceType: dto.serviceType,
            deliveryTime: dto.deliveryTime,
            deliveryTimeType: dto.deliveryTimeType,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: dto.descriptionController,
                  builder: (context, value, child) => Text(
                    dto.descriptionController.text,
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
                          theme.backgroundColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Text(
                        '${SZodiac.of(context).buyZodiac}'
                        ' \$${(dto.price * (dto.discountEnabled ? (1 - dto.discount / 100) : 1)).toStringAsFixed(2)}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 17.0,
                          color: theme.backgroundColor,
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
