import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

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
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 25.0,
        right: 25.0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPhotoPressed,
            child: Assets.vectors.photo.svg(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Type message',
                  hintStyle: TextStyle(
                    color: AppColors.online,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onRecordPressed,
            child: Assets.images.microphoneBig.image(
              height: 32.0,
              width: 32.0,
            ),
          ),
        ],
      ),
    );
  }
}
