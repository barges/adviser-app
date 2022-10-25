import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  const SearchFieldWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.0,
      decoration: BoxDecoration(
          color: Get.theme.hintColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0),
            child: Assets.vectors.search.svg(),
          ),
          Flexible(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  hintText: S.of(context).search,
                  hintStyle: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Get.theme.shadowColor),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 4.0),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none)),
            ),
          ),
        ],
      ),
    );
  }
}
