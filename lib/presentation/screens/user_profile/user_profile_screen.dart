import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/user_profile/user_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class UserProfileScreen extends StatelessWidget {
  final String customerID;

  const UserProfileScreen({Key? key, required this.customerID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => Get.put<UserProfileCubit>(
              UserProfileCubit(customerID),
            ),
        child: Builder(
          builder: (context) {
            final UserProfileCubit userProfileCubit =
                context.read<UserProfileCubit>();
            return Scaffold(
              appBar: WideAppBar(
                bottomWidget: Text(
                  S.of(context).customerProfile,
                  style: Get.textTheme.headlineMedium,
                ),
                topRightWidget: Builder(
                  builder: (context) {
                    final bool isFavorite = context.select(
                      (UserProfileCubit cubit) => cubit.state.isFavorite,
                    );
                    return AppIconButton(
                      icon: isFavorite
                          ? Assets.vectors.filledFavourite.path
                          : Assets.vectors.favourite.path,
                      onTap: userProfileCubit.updateIsFavorite,
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                  child: Column(
                children: [
                  Ink(
                    color: Get.theme.canvasColor,
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding,
                        vertical: 24.0),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SvgPicture.asset('gemini'.getZodiacProfileImage,
                                width: 96.0),
                            if (userProfileCubit.isTopSpender)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 8.0),
                                decoration: BoxDecoration(
                                  color: AppColors.promotion,
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.buttonRadius,
                                  ),
                                ),
                                child: Text(
                                  S.of(context).topSpender,
                                  style: Get.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.white,
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.horizontalScreenPadding),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Text(
                                  'Sylvia Lorente Van Berge Henegouwen',
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.headlineMedium,
                                ),
                              ),
                              Text(
                                '${S.of(context).born} 23/05/1990, female, Chicago IL.',
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Get.theme.shadowColor,
                                ),
                              ),
                              Text(
                                '3 ${S.of(context).chats}, 5 ${S.of(context).calls}, 5 ${S.of(context).services}',
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Get.theme.shadowColor,
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(
                          height: AppConstants.horizontalScreenPadding),
                      Wrap(
                        runSpacing: 8.0,
                        children: [
                          Row(
                            children: [
                              _InfoWidget(
                                title: S.of(context).zodiacSign,
                                info: SvgPicture.asset(
                                    'aquarius'.getHoroscopeByZodiacName),
                              ),
                              const SizedBox(width: 8.0),
                              _InfoWidget(
                                title: S.of(context).numerology,
                                info: Text('2',
                                    style: Get.textTheme.headlineMedium
                                        ?.copyWith(
                                            color: Get.theme.primaryColor)),
                              ),
                              const SizedBox(width: 8.0),
                              _InfoWidget(
                                title: S.of(context).ascendant,
                                info: SvgPicture.asset(
                                    'cancer'.getHoroscopeByZodiacName),
                              ),
                            ],
                          ),
                          const _BirthTownWidget(
                            address: 'Preston Rd. Inglewood, Maine',
                          ),
                          const _QuestionPropertiesWidget(
                            properties: [
                              SessionsTypes.astrology,
                              SessionsTypes.palmreading
                            ],
                          ),
                        ],
                      ),
                    ]),
                  ),
                  const _EmptyNotesWidget()
                ],
              )),
            );
          },
        ));
  }
}

class _InfoWidget extends StatelessWidget {
  final String title;
  final Widget info;

  const _InfoWidget({Key? key, required this.title, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          border: Border.all(
            color: Get.theme.hintColor,
          ),
        ),
        child: Column(children: [
          Text(
            title.toUpperCase(),
            style: Get.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: Get.theme.shadowColor,
            ),
          ),
          const SizedBox(height: 8.0),
          info
        ]),
      ),
    );
  }
}

class _BirthTownWidget extends StatelessWidget {
  final String address;

  const _BirthTownWidget({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          color: Get.theme.hintColor,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          S.of(context).birthTown.toUpperCase(),
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: Get.theme.shadowColor,
          ),
        ),
        const SizedBox(height: 10.0),
        _IconAndTitleWidget(
          iconPath: Assets.vectors.location.path,
          title: address,
        ),
      ]),
    );
  }
}

class _QuestionPropertiesWidget extends StatelessWidget {
  final List<SessionsTypes> properties;

  const _QuestionPropertiesWidget({Key? key, required this.properties})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 12.0, horizontal: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          color: Get.theme.hintColor,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          S.of(context).questionProperties.toUpperCase(),
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w400,
            color: Get.theme.shadowColor,
          ),
        ),
        const SizedBox(height: 10.0),
        ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => _IconAndTitleWidget(
                  iconPath: properties[index].iconPath,
                  title: properties[index].sessionName,
                ),
            separatorBuilder: (_, __) => const SizedBox(height: 12.0),
            itemCount: properties.length)
      ]),
    );
  }
}

class _IconAndTitleWidget extends StatelessWidget {
  final String iconPath;
  final String title;

  const _IconAndTitleWidget(
      {Key? key, required this.iconPath, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(iconPath),
        const SizedBox(width: 4.0),
        Text(
          title,
          style:
              Get.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _EmptyNotesWidget extends StatelessWidget {
  const _EmptyNotesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 24.0, horizontal: AppConstants.horizontalScreenPadding),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).notes,
              style: Get.textTheme.headlineMedium,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.vectors.plus.svg(),
                const SizedBox(width: 9.0),
                GestureDetector(
                  onTap: () {
                    //TODO
                  },
                  child: Text(
                    S.of(context).addNew,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 24.0),
          child: Get.isDarkMode
              ? Assets.images.logos.emptyListLogoDark.image()
              : Assets.images.logos.emptyListLogo.image(),
        ),
        Text(
          S.of(context).youDoNotHaveAnyNotesYet,
          textAlign: TextAlign.center,
          style: Get.textTheme.headlineMedium,
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            S.of(context).addInformationYouWantKeepInMindAboutThisClient,
            textAlign: TextAlign.center,
            style: Get.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: Get.theme.shadowColor,
            ),
          ),
        ),
      ]),
    );
  }
}
