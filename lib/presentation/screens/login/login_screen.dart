import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';import 'package:shared_advisor_interface/presentation/common_widgets/email_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode passwordNode = FocusNode();

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    const _ChooseBrandWidget(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          Obx(() => EmailFieldWidget(
                                showErrorText: !controller.emailIsValid() &&
                                    controller.email.value.isNotEmpty,
                                nextFocusNode: passwordNode,
                                controller: controller.emailController,
                              )),
                          Obx(() {
                            return Padding(
                              padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
                              child: PasswordFieldWidget(
                                controller: controller.passwordController,
                                focusNode: passwordNode,
                                label: S.of(context).password,
                                errorText:
                                    S.of(context).pleaseEnterAtLeast8Characters,
                                textInputAction: TextInputAction.next,
                                showErrorText: !controller.passwordIsValid() &&
                                    controller.password.value.isNotEmpty,
                                onSubmitted: (_) => login,
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
                              Get.toNamed(AppRoutes.forgotPassword);
                            },
                            child: Text(
                              '${S.of(context).forgotYourPassword}?',
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Get.theme.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }

  Future<void> login() async {
    if (controller.emailIsValid() && controller.passwordIsValid()) {
      final bool isLoggedIn = await controller.login();
      if (isLoggedIn) {
        Get.toNamed(
          AppRoutes.home,
        );
      }
    }
  }
}

class _ChooseBrandWidget extends StatelessWidget {
  const _ChooseBrandWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.canvasColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 24.0),
              child: Row(
                children: [
                  Text(
                    S.of(context).chooseBrandToLogIn,
                    style: Get.textTheme.headlineLarge,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          child: SvgPicture.asset(AppIcons.languages),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          '${Get.locale?.languageCode}',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GetBuilder<LoginController>(builder: (controller) {
              return SizedBox(
                height: 77.0,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Brand brand = Configuration.brands[index];
                      return _BrandWidget(
                        brand: Configuration.brands[index],
                        isSelected: brand == controller.selectedBrand.value,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 24.0,
                      );
                    },
                    itemCount: Configuration.brands.length),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _BrandWidget extends StatelessWidget {
  final Brand brand;
  final bool isSelected;

  const _BrandWidget({Key? key, required this.brand, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(brand.isEnabled && !isSelected){

        }
      },
      child: Column(
        children: [
          Container(
            height: 56.0,
            width: 56.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      width: 2.0,
                      color: Get.theme.focusColor,
                    )
                  : null,
            ),
            child: Center(
              child: Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Get.theme.backgroundColor,
                  border: Border.all(
                      color: Get.theme.scaffoldBackgroundColor
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SvgPicture.asset(
                    brand.icon,
                    color: brand.isEnabled ? null : Get.theme.hintColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text( brand.isEnabled ? 
            brand.name : S.of(context).comingSoon,
            style: Get.textTheme.bodySmall?.copyWith(
              color: brand.isEnabled
                  ? isSelected
                      ? Get.theme.focusColor
                      : Get.theme.hoverColor
                  : Get.theme.highlightColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
