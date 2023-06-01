import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/appbar/simple_app_bar.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_cubit.dart';
import 'package:zodiac/presentation/screens/phone_number/widgets/phone_code_search_app_bar.dart';

class PhoneCodeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PhoneCodeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    PhoneNumberCubit phoneNumberCubit = context.read<PhoneNumberCubit>();
    return Builder(builder: (context) {
      final bool isPhoneCodeSearchVisible = context.select(
          (PhoneNumberCubit cubit) => cubit.state.isPhoneCodeSearchVisible);
      return isPhoneCodeSearchVisible
          ? PhoneCodeSearchAppBar(
              onChanged: (text) =>
                  phoneNumberCubit.searchPhoneCountryCodes(text))
          : SimpleAppBar(
              title: SZodiac.of(context).phoneNumberZodiac,
            );
    });
  }
}
