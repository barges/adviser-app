import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/base_screen/runnable_screen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/login_appbar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/email_field_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_succes_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/password_field_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/login/login_controller.dart';

class LoginScreen extends RunnableGetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget body(BuildContext context) {
    final FocusNode passwordNode = FocusNode();

    return Scaffold(
        appBar: LoginAppBar(
          changeLocale: controller.changeLocale,
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
                  child: Column(children: [
                    const SizedBox(
                      height: 16.0,
                    ),
                    Obx(() => _ChooseBrandWidget(
                          selectedBrand: controller.selectedBrand.value,
                        )),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding,
                      ),
                      child: Column(
                        children: [
                          Obx(() => EmailFieldWidget(
                                showErrorText: !controller.emailIsValid() &&
                                    controller.email.value.isNotEmpty,
                                nextFocusNode: passwordNode,
                                controller: controller.emailController,
                              )),
                          const SizedBox(
                            height: 24.0,
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
                              onSubmitted: (_) => controller.login,
                              hiddenPassword: controller.hiddenPassword.value,
                              clickToHide: () {
                                controller.hiddenPassword.value =
                                    !controller.hiddenPassword.value;
                              },
                            );
                          }),
                          const SizedBox(
                            height: 24.0,
                          ),
                          AppElevatedButton(
                            text: S.of(context).login,
                            onPressed: () => controller.login(context),
                          ),
                          const SizedBox(
                            height: 22.0,
                          ),
                          GestureDetector(
                            onTap: controller.goToForgotPassword,
                            child: Text(
                              '${S.of(context).forgotPassword}?',
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
            ),
            Obx(
              () => controller.successMessage.value.isNotEmpty
                  ? AppSuccessWidget(
                      message: controller.successMessage.value,
                      showEmailButton: controller.showOpenEmailButton,
                      close: () {
                        controller.clearSuccessMessage();
                      },
                    )
                  : const SizedBox.shrink(),
            )
          ],
        ));
  }
}

class _ChooseBrandWidget extends GetView<LoginController> {
  final Brand selectedBrand;

  const _ChooseBrandWidget({Key? key, required this.selectedBrand})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Brand> brands = controller.unauthorizedBrands;
    return SizedBox(
      height: 78.0,
      child: ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScreenPadding,
          ),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Brand brand = brands[index];
            return _BrandWidget(
              brand: brands[index],
              isSelected: brand == selectedBrand,
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 8.0,
            );
          },
          itemCount: brands.length),
    );
  }
}

class _BrandWidget extends GetView<LoginController> {
  final Brand brand;
  final bool isSelected;

  const _BrandWidget({Key? key, required this.brand, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = brand.isEnabled;
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.4,
      child: GestureDetector(
        onTap: () {
          if (isEnabled && !isSelected) {
            controller.selectedBrand.value = brand;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: isSelected ? Get.theme.primaryColor : Get.theme.hintColor,
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 2.0),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(AppConstants.buttonRadius - 1),
              color: Get.theme.canvasColor,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 12.0,
                ),
                SvgPicture.asset(
                  brand.icon,
                  color: Get.isDarkMode ? Get.theme.backgroundColor : null,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    isEnabled ? brand.name : S.of(context).comingSoon,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Get.theme.primaryColor
                          : Get.textTheme.bodySmall?.color,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
