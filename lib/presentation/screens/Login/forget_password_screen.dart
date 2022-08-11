import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/login_mixin.dart';
import 'package:shared_advisor_interface/presentation/widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/widgets/custom_text_field_widget.dart';
import 'package:shared_advisor_interface/presentation/widgets/password_field_widget.dart';

class ForgetPasswordScreen extends StatelessWidget with LoginMixin {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();
    final FocusNode confirmPasswordNode = FocusNode();

    return Scaffold(
        backgroundColor: const Color(0xffE5E5E5),
        appBar: SimpleAppBar(title: S.of(context).forgetYourPassword),
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
                      child: SvgPicture.asset(
                          'assets/vectors/forget_password_logo.svg',
                          alignment: Alignment.topCenter),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 29.0, bottom: 16.0),
                      child: CustomTextFieldWidget(
                        controller: emailController,
                        label: S.of(context).email,
                        errorText: S.of(context).theUserWasNotFound,
                        textInputAction: TextInputAction.next,
                        showErrorText: true,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(passwordNode);
                        },
                      ),
                    ),
                    PasswordFieldWidget(
                      focusNode: passwordNode,
                      controller: passwordController,
                      label: S.of(context).password,
                      errorText: S.of(context).pleaseEnterAtLeast8Characters,
                      textInputAction: TextInputAction.next,
                      showErrorText: true,
                      onSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(confirmPasswordNode);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: PasswordFieldWidget(
                        focusNode: confirmPasswordNode,
                        controller: confirmPasswordController,
                        label: S.of(context).confirmNewPassword,
                        errorText: S.of(context).thePasswordsMustMatch,
                        showErrorText: true,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) {
                          resetPassword();
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: resetPassword,
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    const EdgeInsets.symmetric(vertical: 14.0)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ))),
                        child: Text(S.of(context).requestNewPassword,
                            style: const TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }

  void resetPassword() {
    if (isEmail(emailController.text) &&
        !isWeakPassword(passwordController.text) &&
        confirmPasswordController.text == passwordController.text) {
      //TODO -- reset password
    }
  }
}
