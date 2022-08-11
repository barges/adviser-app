import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/resources/routes.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/login_mixin.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/custom_text_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';

class LoginScreen extends StatelessWidget with LoginMixin {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
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
                        dimension: 300,
                        child: SvgPicture.asset(AppIcons.logInLogo,
                            alignment: Alignment.topCenter),
                      ),
                    ),
                    CustomTextFieldWidget(
                      controller: emailController,
                      label: S.of(context).email,
                      errorText: S.of(context).theUserWasNotFound,
                      showErrorText: !isEmail(emailController.text),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        FocusScope.of(context).requestFocus(passwordNode);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                      child: PasswordFieldWidget(
                        focusNode: passwordNode,
                        controller: passwordController,
                        label: S.of(context).password,
                        errorText: S.of(context).pleaseEnterAtLeast8Characters,
                        showErrorText: isWeakPassword(passwordController.text),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) {
                          login();
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(vertical: 14.0)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        child: Text(S.of(context).signIn,
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(fontWeight: FontWeight.w600)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.forgetPassword);
                      },
                      child: Text(
                        "${S.of(context).forgetYourPassword}?".toLowerCase(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColorsLight.secondary),
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }

  void login() {
    if (isEmail(emailController.text) &&
        !isWeakPassword(passwordController.text)) {
      //TODO login
    }
  }
}
