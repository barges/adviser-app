import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';
import 'package:zodiac/presentation/screens/phone_number/phone_number_cubit.dart';

class PhoneCodeItem extends StatelessWidget {
  final PhoneCountryCode phoneCountryCode;
  const PhoneCodeItem({
    super.key,
    required this.phoneCountryCode,
  });

  @override
  Widget build(BuildContext context) {
    PhoneNumberCubit phoneNumberCubit = context.read<PhoneNumberCubit>();
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        phoneNumberCubit.updatePhoneCodeSearchVisibility(false);
        phoneNumberCubit.setPhoneCountryCode(phoneCountryCode);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phoneCountryCode.name ?? '',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 17.0,
              color: theme.hoverColor,
            ),
          ),
          Text(
            phoneCountryCode.code != null ? '+${phoneCountryCode.code}' : '',
            textAlign: TextAlign.left,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.0,
              color: theme.hoverColor,
            ),
          ),
        ],
      ),
    );
  }
}
