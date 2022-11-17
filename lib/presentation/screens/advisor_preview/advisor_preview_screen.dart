import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/widgets/about_me_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/constants.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/widgets/flags_bottom_sheet.dart';

class AdvisorPreviewScreen extends StatelessWidget {
  const AdvisorPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdvisorPreviewCubit(),
      child: Builder(builder: (context) {
        final AdvisorPreviewCubit advisorPreviewCubit =
            context.read<AdvisorPreviewCubit>();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: primary,
            centerTitle: true,
            titleTextStyle: appBarTitleStyle?.copyWith(color: white),
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark),
            leading: GestureDetector(
              onTap: Get.back,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Assets.vectors.arrowLeft.svg(color: white),
              ),
            ),
            title: Text(advisorPreviewCubit.userProfile.profileName ?? ''),
            actions: [
              GestureDetector(
                onTap: () {
                  advisorPreviewCubit.onOpen();
                  flagsBottomSheet(
                      context: context,
                      onApply: advisorPreviewCubit.onApply,
                      onSelectLanguage:
                          advisorPreviewCubit.updateActiveLanguagesInUI,
                      activeLanguages: advisorPreviewCubit.languages,
                      advisorPreviewCubit: advisorPreviewCubit);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding,
                      vertical: 8.0),
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) {
                          final int index = context.select(
                              (AdvisorPreviewCubit cubit) =>
                                  cubit.state.currentIndex);
                          return Image.asset(
                            advisorPreviewCubit.languages[index].flagImagePath,
                          );
                        },
                      ),
                      Assets.vectors.arrowDropDown.svg(),
                    ],
                  ),
                ),
              )
            ],
          ),
          body: ListView(children: [
            Ink(
              color: white,
              child: Stack(
                children: [
                  Image.network(
                    advisorPreviewCubit
                            .userProfile.coverPictures?.firstOrNull ??
                        '',
                    height: 150.0,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 110.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: AppConstants.horizontalScreenPadding,
                              right: AppConstants.horizontalScreenPadding),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              UserAvatar(
                                  diameter: 82.0,
                                  avatarUrl: advisorPreviewCubit.userProfile
                                          .profilePictures?.firstOrNull ??
                                      ''),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Assets.vectors.responseProfile.svg(),
                                          const SizedBox(width: 4.0),
                                          Text('≈ 2 hr', style: displayLarge),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    color: white,
                    height: 47.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: primary, width: 2.0),
                              ),
                            ),
                            child: Text(S.of(context).aboutMe,
                                style: displayLarge),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(S.of(context).quickAnswers,
                                style: displayLarge),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: AppConstants.horizontalScreenPadding),
                    child: Builder(builder: (context) {
                      final int selectedIndex = context.select(
                          (AdvisorPreviewCubit cubit) =>
                              cubit.state.currentIndex);

                      final MarketsType selectedItem =
                          advisorPreviewCubit.languages[selectedIndex];
                      return AboutMeWidget(
                        rating: advisorPreviewCubit.getSelectedLanguageDetails(
                                selectedItem)[ratingKey] ??
                            '',
                        description:
                            advisorPreviewCubit.getSelectedLanguageDetails(
                                    selectedItem)[descriptionKey] ??
                                '',
                        title: advisorPreviewCubit.getSelectedLanguageDetails(
                                selectedItem)[titleKey] ??
                            '',
                        votesNumber: '1555',
                      );
                    }),
                  ),
                ],
              ),
            )
          ]),
        );
      }),
    );
  }
}
