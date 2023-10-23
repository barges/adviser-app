import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_constants.dart';
import '../../../data/models/app_error/app_error.dart';
import '../../../data/models/enums/markets_type.dart';
import '../../../generated/assets/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../global.dart';
import '../../../infrastructure/di/inject_config.dart';
import '../../../main_cubit.dart';
import '../../../themes/app_colors_light.dart';
import '../../common_widgets/messages/app_error_widget.dart';
import '../../common_widgets/user_avatar.dart';
import 'advisor_preview_constants.dart';
import 'advisor_preview_cubit.dart';
import 'widgets/about_me_widget.dart';
import 'widgets/advisor_preview_app_bar.dart';
import 'widgets/cover_picture_widget.dart';

class AdvisorPreviewScreen extends StatelessWidget {
  final bool isAccountTimeout;

  const AdvisorPreviewScreen({
    Key? key,
    required this.isAccountTimeout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdvisorPreviewCubit(
        globalGetIt.get<MainCubit>(),
      ),
      child: Builder(builder: (context) {
        final AdvisorPreviewCubit advisorPreviewCubit =
            context.read<AdvisorPreviewCubit>();
        context.select((AdvisorPreviewCubit cubit) => cubit.state.updateInfo);
        final AppError appError =
            context.select((MainCubit cubit) => cubit.state.appError);
        return Scaffold(
          backgroundColor: AppColorsLight.background,
          appBar: const AdvisorPreviewAppBar(),
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: advisorPreviewCubit.refreshInfo,
                notificationPredicate: (_) => isAccountTimeout,
                child: ListView(
                    physics: const AlwaysScrollableScrollPhysics()
                        .applyTo(const ClampingScrollPhysics()),
                    children: [
                      Ink(
                        color: AdvisorPreviewConstants.white,
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
                                        left: AppConstants
                                            .horizontalScreenPadding,
                                        right: AppConstants
                                            .horizontalScreenPadding),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        UserAvatar(
                                            diameter: 82.0,
                                            avatarUrl: advisorPreviewCubit
                                                    .userProfile
                                                    .profilePictures
                                                    ?.firstOrNull ??
                                                ''),
                                        const SizedBox(width: 12.0),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Assets
                                                        .vectors.responseProfile
                                                        .svg(),
                                                    const SizedBox(width: 4.0),
                                                    const Text('≈ 2 hr',
                                                        style:
                                                            AdvisorPreviewConstants
                                                                .displayLarge),
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
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: AdvisorPreviewConstants.white,
                              height: 47.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: AdvisorPreviewConstants
                                                  .primary,
                                              width: 2.0),
                                        ),
                                      ),
                                      child: Text(
                                          SFortunica.of(context)
                                              .aboutMeFortunica,
                                          style: AdvisorPreviewConstants
                                              .displayLarge),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                          SFortunica.of(context)
                                              .quickAnswersFortunica,
                                          style: AdvisorPreviewConstants
                                              .displayLarge),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            if (advisorPreviewCubit.languages.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal:
                                        AppConstants.horizontalScreenPadding),
                                child: Builder(builder: (context) {
                                  final int selectedIndex = context.select(
                                      (AdvisorPreviewCubit cubit) =>
                                          cubit.state.currentIndex);

                                  final MarketsType selectedItem =
                                      advisorPreviewCubit
                                          .languages[selectedIndex];
                                  return AboutMeWidget(
                                    description: advisorPreviewCubit
                                                .getSelectedLanguageDetails(
                                                    selectedItem)[
                                            AdvisorPreviewConstants
                                                .descriptionKey] ??
                                        '',
                                    title: advisorPreviewCubit
                                                .getSelectedLanguageDetails(
                                                    selectedItem)[
                                            AdvisorPreviewConstants.titleKey] ??
                                        '',
                                  );
                                }),
                              ),
                          ],
                        ),
                      )
                    ]),
              ),
              AppErrorWidget(
                errorMessage: appError.getMessage(context),
                close: advisorPreviewCubit.closeErrorWidget,
              ),
            ],
          ),
        );
      }),
    );
  }
}
