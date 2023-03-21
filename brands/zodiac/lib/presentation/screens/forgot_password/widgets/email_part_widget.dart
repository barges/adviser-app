import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:zodiac/data/models/enums/validation_error_type.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/forgot_password/forgot_password_cubit.dart';

class EmailPart extends StatelessWidget {
  const EmailPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(builder: (context) {
          final ForgotPasswordCubit cubit = context.read<ForgotPasswordCubit>();
          final ValidationErrorType emailErrorType = context.select(
              (ForgotPasswordCubit cubit) => cubit.state.emailErrorType);
          // context
          //     .select((ForgotPasswordCubit cubit) => cubit.state.emailHasFocus);
          return Padding(
            padding: EdgeInsets.only(
              bottom: emailErrorType == ValidationErrorType.empty ? 2.0 : 8.0,
            ),
            child: AppTextField(
              errorType: emailErrorType,
              label: SZodiac.of(context).emailZodiac,
              hintText: SZodiac.of(context).enterYourEmailZodiac,
              focusNode: cubit.emailNode,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: cubit.emailController,
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 24.0),
          child: Text(
            SZodiac.of(context)
                .enterYourEmailAddressAndWeLlSendYouInstructionsToCreateANewPasswordZodiac,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).shadowColor,
                ),
          ),
        ),
      ],
    );
  }
}
