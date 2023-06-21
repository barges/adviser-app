import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_cubit.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_state.dart';

class PhoneNumberTextField extends StatefulWidget {
  final String text;
  const PhoneNumberTextField({
    super.key,
    required this.text,
  });

  @override
  State<PhoneNumberTextField> createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  final FocusNode _phoneNumberInputFocus = FocusNode();
  late final TextEditingController _phoneNumberInputController;

  @override
  void initState() {
    super.initState();

    _phoneNumberInputController = TextEditingController(text: widget.text);
    _phoneNumberInputController.addListener(() {
      PhoneNumberCubit phoneNumberCubit = context.read<PhoneNumberCubit>();
      phoneNumberCubit.setPhoneNumber(_phoneNumberInputController.text);
    });
  }

  @override
  void dispose() {
    _phoneNumberInputController.dispose();
    _phoneNumberInputFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneNumberCubit, PhoneNumberState>(
      listener: (_, state) {
        _setTextInputFocus(
            _phoneNumberInputFocus, state.isPhoneNumberInputFocused);
      },
      child: Builder(builder: (context) {
        final maxLength = context.select(
            (PhoneNumberCubit cubit) => cubit.state.phoneNumberMaxLength);
        if (_phoneNumberInputController.text.length > maxLength) {
          _phoneNumberInputController.text =
              _phoneNumberInputController.text.substring(0, maxLength);
          _phoneNumberInputController.selection = TextSelection.collapsed(
              offset: _phoneNumberInputController.text.length);
        }
        return AppTextField(
          maxLength: maxLength,
          textInputType: TextInputType.number,
          focusNode: _phoneNumberInputFocus,
          controller: _phoneNumberInputController,
          label: SZodiac.of(context).phoneZodiac,
        );
      }),
    );
  }

  void _setTextInputFocus(FocusNode phoneNumberInputFocus, bool value) {
    if (value) {
      phoneNumberInputFocus.requestFocus();
    } else {
      phoneNumberInputFocus.unfocus();
    }
  }
}
