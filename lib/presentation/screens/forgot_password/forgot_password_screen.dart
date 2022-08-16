import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/email_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_controller.dart';

class ForgotPasswordScreen extends GetWidget<ForgotPasswordController> {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();
    final FocusNode confirmPasswordNode = FocusNode();

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: SimpleAppBar(title: S.of(context).forgotYourPassword),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SvgPicture.asset(AppIcons.forgetPasswordLogo,
                          alignment: Alignment.topCenter),
                    ),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.only(top: 28.0, bottom: 16.0),
                        child: EmailFieldWidget(
                          showErrorText: !controller.emailIsValid() &&
                              controller.email.value.isNotEmpty,
                          nextFocusNode: passwordNode,
                          onChanged: (text) {
                            controller.email.value = text;
                          },
                        ),
                      );
                    }),
                    Obx(() {
                      return PasswordFieldWidget(
                        focusNode: passwordNode,
                        label: S.of(context).password,
                        errorText: S.of(context).pleaseEnterAtLeast8Characters,
                        textInputAction: TextInputAction.next,
                        showErrorText: !controller.passwordIsValid() &&
                            controller.password.value.isNotEmpty,
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(confirmPasswordNode);
                        },
                        onChanged: (text) {
                          controller.password.value = text;
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
                          focusNode: confirmPasswordNode,
                          label: S.of(context).confirmNewPassword,
                          errorText: S.of(context).thePasswordsMustMatch,
                          showErrorText: controller.password.value !=
                                  controller.confirmPassword.value &&
                              controller.confirmPassword.value.isNotEmpty,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) {
                            resetPassword();
                          },
                          onChanged: (text) {
                            controller.confirmPassword.value = text;
                          },
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
                      text: S.of(context).requestNewPassword,
                      onPressed: resetPassword,
                    )
                  ]),
            ),
          ),
        ));
  }

  void resetPassword() {
    if (controller.emailIsValid() &&
        controller.passwordIsValid() &&
        controller.password.value == controller.confirmPassword.value) {
      //TODO -- reset password
    }
  }
}
