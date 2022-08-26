import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

class EmailFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool showErrorText;
  final FocusNode? nextFocusNode;

  const EmailFieldWidget({
    Key? key,
    required this.controller,
    this.nextFocusNode,
    this.showErrorText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).email, style: Get.textTheme.labelMedium),
        const SizedBox(
          height: 4.0,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: showErrorText ? Get.theme.errorColor : Get.theme.hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            height: AppConstants.textFieldsHeight - 3,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.buttonRadius - 1),
              color: Get.theme.canvasColor,
            ),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              },
              style: Get.textTheme.bodyMedium,
              maxLines: 1,
              // decoration: showErrorText
              //     ? InputDecoration(
              //         border: OutlineInputBorder(
              //             borderSide: BorderSide(color: Get.theme.errorColor),
              //             borderRadius:
              //                 BorderRadius.circular(AppConstants.buttonRadius)),
              //         errorBorder: OutlineInputBorder(
              //             borderSide: BorderSide(color: Get.theme.errorColor),
              //             borderRadius:
              //                 BorderRadius.circular(AppConstants.buttonRadius)),
              //         focusedBorder: OutlineInputBorder(
              //             borderSide: BorderSide(color: Get.theme.errorColor),
              //             borderRadius:
              //                 BorderRadius.circular(AppConstants.buttonRadius)),
              //         enabledBorder: OutlineInputBorder(
              //             borderSide: BorderSide(color: Get.theme.errorColor),
              //             borderRadius:
              //                 BorderRadius.circular(AppConstants.buttonRadius)),
              //         focusedErrorBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Get.theme.errorColor),
              //           borderRadius:
              //               BorderRadius.circular(AppConstants.buttonRadius),
              //         ),
              //       )
              //     : const InputDecoration(),
            ),
          ),
        ),
        if (showErrorText)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              S.of(context).pleaseInsertCorrectEmail,
              style: Get.textTheme.bodySmall
                  ?.copyWith(color: Get.theme.errorColor),
            ),
          )
      ],
    );
  }
}
