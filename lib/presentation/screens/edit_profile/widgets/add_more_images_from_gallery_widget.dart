import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AddMoreImagesFromGalleryWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const AddMoreImagesFromGalleryWidget({Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppConstants.buttonRadius,
            ),
            color: Get.theme.primaryColorLight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.vectors.add.svg(
              color: Get.theme.primaryColor,
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
              S.current.addMore,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Get.theme.primaryColor,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
