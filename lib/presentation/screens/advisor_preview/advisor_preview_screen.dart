import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/widgets/about_me_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/constants.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/widgets/advisor_preview_app_bar.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/widgets/cover_picture_widget.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';

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
          backgroundColor: AppColorsLight.background,
          appBar: const AdvisorPreviewAppBar(),
          body: ListView(children: [
            Ink(
              color: white,
              child: Stack(
                children: [
                  const CoverPictureWidget(),
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
                        description:
                            advisorPreviewCubit.getSelectedLanguageDetails(
                                    selectedItem)[descriptionKey] ??
                                '',
                        title: advisorPreviewCubit.getSelectedLanguageDetails(
                                selectedItem)[titleKey] ??
                            '',
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
