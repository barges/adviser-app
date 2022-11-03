import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ChatTextfieldWidget extends StatelessWidget {
  final VoidCallback? onPhotoPressed;
  final VoidCallback? onRecordPressed;
  final VoidCallback? onSendPressed;
  final TextEditingController? controller;

  const ChatTextfieldWidget({
    Key? key,
    this.onPhotoPressed,
    this.onRecordPressed,
    this.onSendPressed,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPhotoPressed,
            child: Assets.vectors.photo.svg(width: AppConstants.iconSize),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration.collapsed(
                  hintText: S.of(context).typemessage,
                  hintStyle: Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.shadowColor,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onRecordPressed,
            child: Assets.images.microphoneBig.image(
              height: AppConstants.iconButtonSize,
              width: AppConstants.iconButtonSize,
            ),
          ),
        ],
      ),
    );
  }
}
