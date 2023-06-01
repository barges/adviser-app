import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_cubit.dart';
import 'package:zodiac/presentation/screens/phone_number/widgets/phone_code_item.dart';

class PhoneCodeSearchWidget extends StatelessWidget {
  const PhoneCodeSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final List<PhoneCountryCode> searchedPhoneCountryCodes = context.select(
          (PhoneNumberCubit cubit) => cubit.state.searchedPhoneCountryCodes);
      return Container(
        decoration: BoxDecoration(color: Theme.of(context).canvasColor),
        child: ListView.separated(
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
        ),
      );
    });
  }
}
