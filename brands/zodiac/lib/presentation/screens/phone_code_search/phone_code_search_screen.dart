import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';
import 'package:zodiac/presentation/screens/phone_code_search/phone_code_search_cubit.dart';
import 'package:zodiac/presentation/screens/phone_code_search/widgets/phone_code_item.dart';
import 'package:zodiac/presentation/screens/phone_code_search/widgets/phone_code_search_app_bar.dart';

class PhoneCodeSearchScreen extends StatelessWidget {
  const PhoneCodeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhoneCodeSearchCubit(),
      child: Builder(builder: (context) {
        PhoneCodeSearchCubit phoneCodeSearchCubit =
            context.read<PhoneCodeSearchCubit>();
        return Scaffold(
          appBar: PhoneCodeSearchAppBar(
              onChanged: (text) =>
                  phoneCodeSearchCubit.searchPhoneCountryCodes(text)),
          backgroundColor: Theme.of(context).canvasColor,
          body: SafeArea(
            top: false,
            child: Builder(builder: (context) {
              final List<PhoneCountryCode> searchedPhoneCountryCodes =
                  context.select((PhoneCodeSearchCubit cubit) =>
                      cubit.state.searchedPhoneCountryCodes);
              return ListView.separated(
                padding: const EdgeInsets.only(
                  top: AppConstants.horizontalScreenPadding,
                  left: AppConstants.horizontalScreenPadding,
                ),
                itemBuilder: (_, index) {
                  final phoneCountryCode = searchedPhoneCountryCodes[index];
                  return PhoneCodeItem(
                    phoneCountryCode: phoneCountryCode,
                    isBottomDivider:
                        index == searchedPhoneCountryCodes.length - 1,
                  );
                },
                separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.only(top: 9.0, bottom: 8.0),
                    child: SizedBox(
                      height: 1.0,
                      child: Divider(),
                    )),
                itemCount: searchedPhoneCountryCodes.length,
              );
            }),
          ),
        );
      }),
    );
  }
}
