import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_cubit.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_state.dart';
import 'package:zodiac/presentation/screens/phone_number/widgets/phone_code_item.dart';
import 'package:zodiac/presentation/screens/phone_number/widgets/phone_code_search_app_bar.dart';

class PhoneCodeSearchWidget extends StatefulWidget {
  final FocusNode _phoneCodeSearchFocus = FocusNode();

  PhoneCodeSearchWidget({super.key});

  @override
  State<PhoneCodeSearchWidget> createState() => _PhoneCodeSearchWidgetState();
}

class _PhoneCodeSearchWidgetState extends State<PhoneCodeSearchWidget> {
  @override
  void dispose() {
    widget._phoneCodeSearchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PhoneNumberCubit phoneNumberCubit = context.read<PhoneNumberCubit>();
    return BlocListener<PhoneNumberCubit, PhoneNumberState>(
      listener: (_, state) {
        if (Platform.isAndroid) {
          if (state.isPhoneCodeSearchFocused &&
              state.isPhoneCodeSearchVisible) {
            widget._phoneCodeSearchFocus.requestFocus();
          } else if (state.isPhoneCodeSearchVisible) {
            widget._phoneCodeSearchFocus.unfocus();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: PhoneCodeSearchAppBar(
          onChanged: (text) => phoneNumberCubit.searchPhoneCountryCodes(text),
          focusNode: widget._phoneCodeSearchFocus,
        ),
        body: SafeArea(
          child: Builder(builder: (context) {
            final List<PhoneCountryCode> searchedPhoneCountryCodes =
                context.select((PhoneNumberCubit cubit) =>
                    cubit.state.searchedPhoneCountryCodes);
            return ListView.separated(
              padding: const EdgeInsets.only(
                top: AppConstants.horizontalScreenPadding,
                left: AppConstants.horizontalScreenPadding,
              ),
              itemBuilder: (_, index) {
                final PhoneCountryCode? phoneCountryCode =
                    index != searchedPhoneCountryCodes.length
                        ? searchedPhoneCountryCodes[index]
                        : null;
                return index != searchedPhoneCountryCodes.length
                    ? PhoneCodeItem(
                        phoneCountryCode: phoneCountryCode!,
                      )
                    : const SizedBox.shrink();
              },
              separatorBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(top: 9.0, bottom: 8.0),
                  child: SizedBox(
                    height: 1.0,
                    child: Divider(),
                  )),
              itemCount: searchedPhoneCountryCodes.length + 1,
            );
          }),
        ),
      ),
    );
  }
}
