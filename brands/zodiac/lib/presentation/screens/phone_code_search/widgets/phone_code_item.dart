import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';

class PhoneCodeItem extends StatelessWidget {
  final PhoneCountryCode phoneCountryCode;
  final bool isBottomDivider;
  const PhoneCodeItem({
    super.key,
    required this.phoneCountryCode,
    this.isBottomDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pop<PhoneCountryCode>(phoneCountryCode),
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
          if (isBottomDivider)
            const Padding(
              padding: EdgeInsets.only(top: 9.0),
              child: SizedBox(
                height: 1.0,
                child: Divider(),
              ),
            ),
        ],
      ),
    );
  }
}
