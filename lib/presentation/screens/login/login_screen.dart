import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/email_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
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
              child: Column(children: [
                const _TopPartWidget(),
                Obx(() => _ChooseBrandWidget(
                      selectedBrand: controller.selectedBrand.value,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: EmailFieldWidget(
                              showErrorText: !controller.emailIsValid() &&
                                  controller.email.value.isNotEmpty,
                              nextFocusNode: passwordNode,
                              controller: controller.emailController,
                            ),
                          )),
                      Obx(() {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 18.0),
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
                        text: S.of(context).login,
                        onPressed: login,
                      ),
                      TextButton(
                        onPressed: () {
                          '${Get.toNamed(AppRoutes.forgotPassword)}?';
                        },
                        child: Text(
                          S.of(context).forgotPassword,
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
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

class _TopPartWidget extends GetView<LoginController> {
  const _TopPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.canvasColor,
      padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 20.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              S.of(context).chooseBrandToLogIn,
              style: Get.textTheme.headlineLarge,
              softWrap: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: controller.changeLocale,
                  child: SvgPicture.asset(AppIcons.languages),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  Intl.getCurrentLocale().capitalize ?? '',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ChooseBrandWidget extends GetView<LoginController> {
  final Brand selectedBrand;

  const _ChooseBrandWidget({Key? key, required this.selectedBrand})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.canvasColor,
      padding: const EdgeInsets.only(bottom: 24.0),
      child: SizedBox(
        height: 77.0,
        child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Brand brand = Configuration.brands[index];
              return _BrandWidget(
                brand: Configuration.brands[index],
                isSelected: brand == selectedBrand,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 24.0,
              );
            },
            itemCount: Configuration.brands.length),
      ),
    );
  }
}

class _BrandWidget extends GetView<LoginController> {
  final Brand brand;
  final bool isSelected;

  _BrandWidget({Key? key, required this.brand, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (brand.isEnabled && !isSelected) {
          controller.selectedBrand.value = brand;
        }
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 56.0,
                width: 56.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected
                      ? LinearGradient(colors: [
                          Get.theme.primaryColorLight,
                          Get.theme.primaryColorDark
                        ])
                      : null,
                ),
              ),
              Container(
                height: 52.0,
                width: 52.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Get.theme.canvasColor,
                ),
                child: Center(
                  child: Container(
                    height: 48.0,
                    width: 48.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Get.theme.backgroundColor,
                        border: Border.all(
                            color: Get.theme.scaffoldBackgroundColor)),
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
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            brand.isEnabled ? brand.name : S.of(context).comingSoon,
            style: brand.isEnabled
                ? Get.textTheme.bodySmall?.copyWith(
                    foreground:
                        isSelected ? (Paint()..shader = linearGradient) : null,
                    color: isSelected ? null : Get.theme.hoverColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  )
                : Get.textTheme.bodySmall?.copyWith(
                    color: Get.theme.highlightColor,
                    fontWeight: FontWeight.w500,
                  ),
          )
        ],
      ),
    );
  }

  final Shader linearGradient = LinearGradient(
          colors: [Get.theme.primaryColorLight, Get.theme.primaryColorDark])
      .createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
}
