import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/no_connection_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/widgets/email_part_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/widgets/reset_password_input_part.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/widgets/success_reset.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(getIt.get<AuthRepository>()),
      child: Builder(
        builder: (context) {
          final ForgotPasswordCubit cubit = context.read<ForgotPasswordCubit>();
          final bool isOnline = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
          return Scaffold(
            appBar: SimpleAppBar(
              title: S.of(context).forgotPassword,
            ),
            body: SafeArea(
              child: isOnline
                  ? Builder(builder: (context) {
                      final bool isResetSuccess = context.select(
                          (ForgotPasswordCubit cubit) =>
                              cubit.state.isResetSuccess);
                      return isResetSuccess
                          ? const SuccessResetWidget()
                          : GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                cubit.clearErrorMessage();
                              },
                              child: Column(
                                children: [
                                  Builder(
                                    builder: (BuildContext context) {
                                      final String errorMessage =
                                          context.select((MainCubit cubit) =>
                                              cubit.state.errorMessage);
                                      return errorMessage.isNotEmpty
                                          ? AppErrorWidget(
                                              errorMessage: errorMessage,
                                              close: () {
                                                cubit.clearErrorMessage();
                                              },
                                            )
                                          : const SizedBox.shrink();
                                    },
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppConstants
                                              .horizontalScreenPadding),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 24.0),
                                            child: _BrandLogo(),
                                          ),
                                          Builder(builder: (context) {
                                            final String? resetToken = context
                                                .select((ForgotPasswordCubit
                                                        cubit) =>
                                                    cubit.state.resetToken);
                                            return Column(
                                              children: [
                                                resetToken == null
                                                    ? const EmailPart()
                                                    : const ResetPasswordInputPart(),
                                                Builder(builder: (context) {
                                                  final bool isActive =
                                                      context.select(
                                                    (ForgotPasswordCubit
                                                            cubit) =>
                                                        cubit.state
                                                            .isButtonActive,
                                                  );
                                                  return AppElevatedButton(
                                                    title: resetToken == null
                                                        ? S
                                                            .of(context)
                                                            .resetPassword
                                                        : S
                                                            .of(context)
                                                            .changePassword,
                                                    onPressed: isActive
                                                        ? () =>
                                                            cubit.resetPassword(
                                                                resetToken)
                                                        : null,
                                                  );
                                                }),
                                              ],
                                            );
                                          }),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 24.0,
                                            ),
                                            child: Utils.isDarkMode(context)
                                                ? Assets.images.logos
                                                    .forgotPasswordLogoDark
                                                    .image(
                                                    height:
                                                        AppConstants.logoSize,
                                                    width:
                                                        AppConstants.logoSize,
                                                  )
                                                : Assets.images.logos
                                                    .forgotPasswordLogo
                                                    .image(
                                                    height:
                                                        AppConstants.logoSize,
                                                    width:
                                                        AppConstants.logoSize,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    })
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        NoConnectionWidget(),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Brand brand = context
        .select((ForgotPasswordCubit cubit) => cubit.state.selectedBrand);
    return GestureDetector(
      onDoubleTap: () {
        if (kDebugMode) {
          context.read<ForgotPasswordCubit>().emailController.text =
              'niskov.test@gmail.com';
        }
      },
      child: Container(
        height: 96.0,
        width: 96.0,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            AppConstants.buttonRadius,
          ),
          color: Get.theme.canvasColor,
        ),
        child: Center(
          child: SvgPicture.asset(
            brand.icon,
            height: 72.0,
          ),
        ),
      ),
    );
  }
}
