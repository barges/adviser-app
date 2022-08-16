import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/resources/routes.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/email_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_controller.dart';

class LoginScreen extends GetWidget<LoginController> {
 const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: SimpleAppBar(title: S.of(context).login),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 44.0),
                      child: SizedBox.square(
                        dimension: 300.0,
                        child: SvgPicture.asset(AppIcons.logInLogo,
                            alignment: Alignment.topCenter),
                      ),
                    ),
                    Obx(() => EmailFieldWidget(
                          showErrorText: !controller.emailIsValid() &&
                              controller.email.value.isNotEmpty,
                          nextFocusNode: passwordNode,
                          onChanged: (text) {
                            controller.email.value = text;
                          },
                        )),
                    Obx(() {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                        child:  PasswordFieldWidget(
                        focusNode: passwordNode,
                        label: S.of(context).password,
                        errorText: S.of(context).pleaseEnterAtLeast8Characters,
                        textInputAction: TextInputAction.next,
                        showErrorText: !controller.passwordIsValid() &&
                            controller.password.value.isNotEmpty,
                        onSubmitted:(_) => login,
                        onChanged: (text) {
                          controller.password.value = text;
                        },
                        hiddenPassword: controller.hiddenPassword.value,
                        clickToHide: () {
                          controller.hiddenPassword.value =
                          !controller.hiddenPassword.value;
                        },
                      ),
                      );
                    }),
                    AppElevatedButton(
                      text: S.of(context).signIn,
                      onPressed: login,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.forgotPassword);
                      },
                      child: Text(
                        '${S.of(context).forgotYourPassword}?',
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Get.theme.primaryColor),
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }

  void login() {
    if (controller.emailIsValid() && controller.passwordIsValid()) {
     controller.login();
    }
  }
}
