import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/user_info/preferred_locale.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';

class ClientInformationWidget extends StatelessWidget {
  final bool chatIsActive;

  const ClientInformationWidget({
    Key? key,
    required this.chatIsActive,
  }) : super(key: key);

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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: 1,
          child: child,
        );
      },
      child: shouldOpenWidget
          ? Column(
              children: [
                Container(
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
                                    text: SZodiac.of(context)
                                        .preferredLanguageZodiac,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.shadowColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: preferredLocale.nameNative ??
                                            preferredLocale.codeAsTitle ??
                                            preferredLocale.code ??
                                            '',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
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
                        ),
                    ],
                  ),
                ),
                if (chatIsActive) const _UnderageReportWidget(),
              ],
            )
          : const SizedBox.shrink(),
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

class _UnderageReportWidget extends StatelessWidget {
  const _UnderageReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();

    return GestureDetector(
      onTap: chatCubit.underageConfirm,
      child: Container(
        decoration: BoxDecoration(
          color: theme.canvasColor,
          border: Border(
            bottom: BorderSide(color: theme.hintColor),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(children: [
          Assets.zodiac.underageReportIcon.svg(
            height: AppConstants.iconSize,
            width: AppConstants.iconSize,
            color: AppColors.error,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              SZodiac.of(context).reportUnderageUserZodiac,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
          Assets.vectors.arrowRight.svg(
            height: AppConstants.iconSize,
            width: AppConstants.iconSize,
            color: AppColors.error,
          )
        ]),
      ),
    );
  }
}
