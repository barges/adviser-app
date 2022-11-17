import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/network/requests/reset_password_request.dart';
import 'package:shared_advisor_interface/domain/repositories/auth_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/screens/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final BuildContext _context;
  final AuthRepository _repository;

  final MainCubit _mainCubit = getIt.get<MainCubit>();

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  late final ForgotPasswordScreenArguments arguments;

  ForgotPasswordCubit(this._context, this._repository)
      : super(const ForgotPasswordState()) {
    arguments = Get.arguments as ForgotPasswordScreenArguments;
    //ModalRoute.of(_context)?.settings.arguments

    if(arguments.token == null) {
      emailNode.addListener(() {
        emit(state.copyWith(emailHasFocus: emailNode.hasFocus));
      });

      emailController.addListener(() {
        clearErrorMessage();
        emit(state.copyWith(
          emailErrorText: '',
        ));
      });
    } else{

      _verifyToken();

      passwordNode.addListener(() {
        emit(state.copyWith(passwordHasFocus: passwordNode.hasFocus));
      });

      confirmPasswordNode.addListener(() {
        emit(state.copyWith(
            confirmPasswordHasFocus: confirmPasswordNode.hasFocus));
      });


      passwordController.addListener(() {
        clearErrorMessage();
        emit(state.copyWith(
          passwordErrorText: '',
        ));
      });

      confirmPasswordController.addListener(() {
        clearErrorMessage();
        emit(state.copyWith(
          confirmPasswordErrorText: '',
        ));
      });
    }
  }

  @override
  Future<void> close() async {
    emailController.dispose();
    emailNode.dispose();
    passwordController.dispose();
    passwordNode.dispose();
    confirmPasswordController.dispose();
    confirmPasswordNode.dispose();
    return super.close();
  }

  void showHidePassword() {
    emit(state.copyWith(hiddenPassword: !state.hiddenPassword));
  }

  void showHideConfirmPassword() {
    emit(state.copyWith(hiddenConfirmPassword: !state.hiddenConfirmPassword));
  }

  Future<void> resetPassword() async {
    if(arguments.token == null){
     await sendEmailForReset();
    }else{
      await changePassword();
    }
  }

  Future<void> sendEmailForReset() async {
    if (emailIsValid()) {
      final bool success = await _repository.sendEmailForReset(
        ResetPasswordRequest(
          email: emailController.text,
        ),
      );
      if (success) {
        Get.back();
        _mainCubit.updateSuccessMessage(
            S.current.youHaveSuccessfullyChangedYourPasswordCheckYourEmailTo);
      }
    } else {
      if (!emailIsValid()) {
        emit(
          state.copyWith(emailErrorText: S.current.pleaseInsertCorrectEmail),
        );
      }
    }
  }

  Future<bool> _verifyToken() async {
    try {
      return _repository.verifyToken(token: 'token');
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<void> changePassword() async {
    if (passwordIsValid() && confirmPasswordIsValid()) {
      final bool success = await _repository.sendPasswordForReset(
       request: ResetPasswordRequest(
          password: passwordController.text,
        ),
        token: 'AAAAAAAAA',
      );
      if (success) {

      }
    } else {
      if (!passwordIsValid()) {
        emit(
          state.copyWith(
            passwordErrorText: S.current.pleaseEnterAtLeast6Characters,
          ),
        );
      }
      if (!confirmPasswordIsValid()) {
        emit(
          state.copyWith(
            confirmPasswordErrorText: S.current.thePasswordsMustMatch,
          ),
        );
      }
    }
  }

  void clearErrorMessage() {
    _mainCubit.clearErrorMessage();
  }

  bool emailIsValid() => GetUtils.isEmail(emailController.text);

  bool passwordIsValid() => passwordController.text.length >= 6;

  bool confirmPasswordIsValid() =>
      passwordController.text == confirmPasswordController.text;
}
