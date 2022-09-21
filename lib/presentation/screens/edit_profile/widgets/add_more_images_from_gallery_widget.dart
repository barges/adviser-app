import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class AddMoreImagesFromGalleryWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const AddMoreImagesFromGalleryWidget({Key? key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: Get.width * 0.29,
        width: Get.width * 0.29,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Get.theme.primaryColor.withOpacity(0.15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.vectors.add.svg(
                color: Get.theme.primaryColor,
              ),
              const SizedBox(height: 6.0),
              Text(S.current.addMore,
                  style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Get.theme.primaryColor))
            ]),
      ),
    );
  }
}
