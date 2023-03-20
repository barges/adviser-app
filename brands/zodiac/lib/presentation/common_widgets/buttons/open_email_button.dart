import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:zodiac/generated/l10n.dart';

class OpenEmailButton extends StatelessWidget {
  const OpenEmailButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
          onTap: () async {
            var result = await OpenMailApp.openMailApp(
                nativePickerTitle: SZodiac.of(context).chooseEmailAppZodiac);
            if (Platform.isIOS && result.options.length > 1) {
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (_) {
                  return MailAppPickerDialog(
                    title: SZodiac.of(context).chooseEmailAppZodiac,
                    mailApps: result.options,
                  );
                },
              );
            }
          },
          child: Text(
            SZodiac.of(context).openEmailZodiac,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
          )),
    );
  }
}
