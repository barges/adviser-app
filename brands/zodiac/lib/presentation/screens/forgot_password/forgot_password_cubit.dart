import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/app_success/app_success.dart';
import 'package:zodiac/data/models/app_success/ui_success_type.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/data/network/requests/forgot_password_request.dart';
import 'package:zodiac/domain/repositories/auth_repository.dart';
import 'package:zodiac/presentation/screens/forgot_password/forgot_password_state.dart';
import 'package:zodiac/presentation/screens/login/login_cubit.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();

  final AuthRepository _authRepository;
  final ZodiacMainCubit _zodiacMainCubit;
  final LoginCubit _loginCubit;

  ForgotPasswordCubit(
    this._authRepository,
    this._zodiacMainCubit,
    this._loginCubit,
  ) : super(const ForgotPasswordState());

  void clearErrorMessage() {
    _zodiacMainCubit.clearErrorMessage();
  }

  Future<void> resetPassword(BuildContext context) async {
    try {
      if (emailIsValid()) {
        await _authRepository.forgotPassword(
            request: ForgotPasswordRequest(email: emailController.text));
        _loginCubit.updateSuccessMessage(
          UISuccess.withArguments(
            UISuccessMessagesType.weVeSentPasswordResetInstructionsToEmail,
            emailController.text,
          ),
        );
        // ignore: use_build_context_synchronously
        context.pop();
      } else {
        emit(
          state.copyWith(
              emailErrorType: ValidationErrorType.pleaseInsertCorrectEmail),
        );
      }
    } catch (e) {
      logger.d(e);
    }
  }

  bool emailIsValid() => Utils.isEmail(emailController.text);
}
