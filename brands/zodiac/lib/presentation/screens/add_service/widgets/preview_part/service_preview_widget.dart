import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/services/image_sample_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/add_service/add_service_cubit.dart';
import 'package:zodiac/presentation/screens/add_service/widgets/preview_part/service_preview_image_widget.dart';

class ServicePreviewWidget extends StatelessWidget {
  final List<ImageSampleModel> images;

  const ServicePreviewWidget({
    Key? key,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AddServiceCubit addServiceCubit = context.read<AddServiceCubit>();

    context.select((AddServiceCubit cubit) => cubit.state.updateAfterDuplicate);

    final int selectedLanguageIndex = context
        .select((AddServiceCubit cubit) => cubit.state.selectedLanguageIndex);

    final TextEditingController descriptionController = addServiceCubit
        .textControllersMap.entries
        .toList()[selectedLanguageIndex]
        .value[descriptionIndex];

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
            selectedLanguageIndex: selectedLanguageIndex,
            images: images,
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
                Builder(builder: (context) {
                  final double price = context
                      .select((AddServiceCubit cubit) => cubit.state.price);
                  final double discount = context
                      .select((AddServiceCubit cubit) => cubit.state.discount);
                  final bool discountEnabled = context.select(
                      (AddServiceCubit cubit) => cubit.state.discountEnabled);

                  return Container(
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
                  );
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
