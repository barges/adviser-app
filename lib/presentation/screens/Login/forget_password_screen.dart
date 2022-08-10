import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/widgets/custom_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/widgets/custom_text_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/widgets/password_field_widget.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffE5E5E5),
        appBar: CustomAppBar(title: S.of(context).forgetYourPassword),
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
                          controller: TextEditingController(),
                          label: S.of(context).email,
                          errorText: 'The user was not found',
                          showErrorText: true),
                    ),
                    PasswordFieldWidget(
                        controller: TextEditingController(),
                        label: S.of(context).password,
                        errorText: 'The user was not found',
                        showErrorText: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: PasswordFieldWidget(
                          controller: TextEditingController(),
                          label: S.of(context).confirmYourPassword,
                          errorText: 'The user was not found',
                          showErrorText: true),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {},
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
}
