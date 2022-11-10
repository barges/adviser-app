import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ChatItemBg extends StatelessWidget {
  final bool border;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Widget child;
  const ChatItemBg({
    super.key,
    required this.padding,
    required this.color,
    required this.child,
    this.border = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12.0,
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          border: border
              ? Border.all(
                  width: 1,
                  color: Get.theme.primaryColor,
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}
