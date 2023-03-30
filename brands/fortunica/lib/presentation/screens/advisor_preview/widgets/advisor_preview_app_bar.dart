import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/presentation/screens/advisor_preview/advisor_preview_constants.dart';
import 'package:fortunica/presentation/screens/advisor_preview/advisor_preview_cubit.dart';
import 'package:fortunica/presentation/screens/advisor_preview/widgets/flags_bottom_sheet.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';

class AdvisorPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const AdvisorPreviewAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdvisorPreviewCubit advisorPreviewCubit =
        context.read<AdvisorPreviewCubit>();
    context.select((AdvisorPreviewCubit cubit) => cubit.state.updateInfo);
    return AppBar(
      backgroundColor: AdvisorPreviewConstants.primary,
      centerTitle: true,
      titleTextStyle: AdvisorPreviewConstants.appBarTitleStyle
          .copyWith(color: AdvisorPreviewConstants.white),
      systemOverlayStyle:
          const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      leading: GestureDetector(
        onTap: context.pop,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Assets.vectors.arrowLeft
              .svg(color: AdvisorPreviewConstants.white),
        ),
      ),
      title: Text(advisorPreviewCubit.userProfile.profileName ?? ''),
      actions: [
        if (advisorPreviewCubit.languages.isNotEmpty)
          GestureDetector(
            onTap: advisorPreviewCubit.languages.length > 1
                ? () {
                    advisorPreviewCubit.onOpen();
                    flagsBottomSheet(
                        context: context,
                        onApply: () {
                          advisorPreviewCubit.onApply();
                          context.pop();
                        },
                        onSelectLanguage:
                            advisorPreviewCubit.updateActiveLanguagesInUI,
                        activeLanguages: advisorPreviewCubit.languages,
                        advisorPreviewCubit: advisorPreviewCubit);
                  }
                : null,
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
                  advisorPreviewCubit.languages.length > 1
                      ? Assets.vectors.arrowDropDown.svg()
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}