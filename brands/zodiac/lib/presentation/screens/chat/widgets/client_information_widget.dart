import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/user_info/preferred_locale.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';

class ClientInformationWidget extends StatelessWidget {
  const ClientInformationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final UserDetails? clientInformation =
        context.select((ChatCubit cubit) => cubit.state.clientInformation);
    final bool clientInformationWidgetOpened = context
        .select((ChatCubit cubit) => cubit.state.clientInformationWidgetOpened);

    final String? shortDescription = clientInformation?.shortDescription;
    final PreferredLocale? preferredLocale = clientInformation?.preferredLocale;
    final bool? isFreeBeerDrinker = clientInformation?.isFreeBeerDrinker;

    final bool shouldOpenWidget = clientInformationWidgetOpened &&
        (shortDescription?.isNotEmpty == true ||
            preferredLocale != null ||
            isFreeBeerDrinker == true);

    return AnimatedSlide(
      offset: shouldOpenWidget ? const Offset(0, 0) : const Offset(0, -1),
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          border: Border(
            bottom: BorderSide(color: theme.hintColor),
            top: BorderSide(color: theme.hintColor),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shortDescription?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  shortDescription!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.shadowColor,
                  ),
                ),
              ),
            if (preferredLocale != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                          text: SZodiac.of(context).preferredLanguageZodiac,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.shadowColor,
                          ),
                          children: [
                            TextSpan(
                              text: preferredLocale.nameNative ??
                                  preferredLocale.codeAsTitle ??
                                  preferredLocale.code ??
                                  '',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontSize: 13.0,
                                color: theme.shadowColor,
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    if (preferredLocale.flagIcon?.isNotEmpty == true)
                      CachedNetworkImage(
                        imageUrl: preferredLocale.flagIcon!,
                        height: 16.0,
                        width: 16.0,
                      )
                  ],
                ),
              ),
            if (isFreeBeerDrinker == true)
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: _FreebieSeekerWidget(),
              )
          ],
        ),
      ),
    );
  }
}

class _FreebieSeekerWidget extends StatelessWidget {
  const _FreebieSeekerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: AppColors.promotion,
      ),
      child: Text(
        SZodiac.of(context).freebieSeeker.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          fontSize: 12.0,
          color: theme.backgroundColor,
        ),
      ),
    );
  }
}
