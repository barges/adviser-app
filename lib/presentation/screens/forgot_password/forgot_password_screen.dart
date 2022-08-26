import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/email_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/runnable_screen/runnable_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_controller.dart';

class ForgotPasswordScreen extends RunnableGetView<ForgotPasswordController> {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget body(BuildContext context) {
    final FocusNode passwordNode = FocusNode();
    final FocusNode confirmPasswordNode = FocusNode();

    return Scaffold(
        appBar: WideAppBar(
          title: S.of(context).forgotPassword,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  controller.clearErrorMessage();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: _BrandLogo(
                            brand: controller.currentBrand,
                          ),
                        ),
                        Obx(() {
                          return EmailFieldWidget(
                            showErrorText: !controller.emailIsValid() &&
                                controller.email.value.isNotEmpty,
                            nextFocusNode: passwordNode,
                            controller: controller.emailController,
                          );
                        }),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Obx(() {
                          return PasswordFieldWidget(
                            controller: controller.passwordController,
                            focusNode: passwordNode,
                            label: S.of(context).password,
                            errorText:
                                S.of(context).pleaseEnterAtLeast8Characters,
                            textInputAction: TextInputAction.next,
                            showErrorText: !controller.passwordIsValid() &&
                                controller.password.value.isNotEmpty,
                            onSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(confirmPasswordNode);
                            },
                            hiddenPassword: controller.hiddenPassword.value,
                            clickToHide: () {
                              controller.hiddenPassword.value =
                                  !controller.hiddenPassword.value;
                            },
                          );
                        }),
                        Obx(() {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: PasswordFieldWidget(
                              controller: controller.confirmPasswordController,
                              focusNode: confirmPasswordNode,
                              label: S.of(context).confirmNewPassword,
                              errorText: S.of(context).thePasswordsMustMatch,
                              showErrorText: controller.password.value !=
                                      controller.confirmPassword.value &&
                                  controller.confirmPassword.value.isNotEmpty,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => controller.resetPassword(context),
                              hiddenPassword:
                                  controller.hiddenConfirmPassword.value,
                              clickToHide: () {
                                controller.hiddenConfirmPassword.value =
                                    !controller.hiddenConfirmPassword.value;
                              },
                            ),
                          );
                        }),
                        AppElevatedButton(
                          text: S.of(context).changePassword,
                          onPressed: () => controller.resetPassword(context),
                        )
                      ]),
                ),
              ),
            ),
            Obx(
              () => controller.errorMessage.value.isNotEmpty
                  ? AppErrorWidget(
                      errorMessage: controller.errorMessage.value,
                      close: () {
                        controller.clearErrorMessage();
                      },
                    )
                  : const SizedBox.shrink(),
            )
          ],
        ));
  }
}

class _BrandLogo extends GetView<ForgotPasswordController> {
  final Brand? brand;

  const _BrandLogo({Key? key, required this.brand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96.0,
      width: 96.0,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Get.theme.canvasColor,
      ),
      child: Center(
        child: SvgPicture.asset(
          brand?.icon ?? '',
          height: 72.0,
        ),
      ),
    );
  }
}
