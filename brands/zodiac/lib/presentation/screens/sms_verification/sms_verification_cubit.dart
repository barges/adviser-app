import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/sms_verification/sms_verification_state.dart';

class SMSVerificationCubitCubit extends Cubit<SMSVerificationState> {
  final codeTextFieldFocus = FocusNode();
  SMSVerificationCubitCubit() : super(const SMSVerificationState()) {
    codeTextFieldFocus.addListener(() {
      print(codeTextFieldFocus.hasPrimaryFocus);
    });

    /*emit(state.copyWith(
      isError: false,
    ));*/
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
