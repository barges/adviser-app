import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:open_mail_app/open_mail_app.dart';

class OpenEmailButton extends StatelessWidget {
  const OpenEmailButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
          onTap: () async {
            var result = await OpenMailApp.openMailApp(
                nativePickerTitle: SFortunica.of(context).chooseEmailAppFortunica);
            if (Platform.isIOS && result.options.length > 1) {
              showDialog(
                context: context,
                builder: (_) {
                  return MailAppPickerDialog(
                    title: SFortunica.of(context).chooseEmailAppFortunica,
                    mailApps: result.options,
                  );
                },
              );
            }
          },
          child: Text(
            SFortunica.of(context).openEmailFortunica,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                ),
          )),
    );
  }
}
