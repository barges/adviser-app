import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/forget_password_screen.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/widgets/custom_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/Login/widgets/custom_text_field_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffE5E5E5),
        appBar: CustomAppBar(title: S.of(context).login),
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
                        child: SvgPicture.asset('assets/vectors/login_logo.svg',
                            alignment: Alignment.topCenter),
                      ),
                    ),
                    CustomTextFieldWidget(
                        controller: TextEditingController(),
                        label: S.of(context).email,
                        errorText: 'The user was not found',
                        showErrorText: true),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                      child: CustomTextFieldWidget(
                          controller: TextEditingController(),
                          label: S.of(context).password,
                          errorText: 'Password is not correct!',
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
                        child: Text(S.of(context).signIn,
                            style: const TextStyle(
                                fontSize: 17.0, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        /*Get.to((ForgetPasswordScreen).toString());*/
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen()));
                      },
                      child: Text(
                        "${S.of(context).forgetYourPassword}?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}
