import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/advisor_preview/advisor_preview_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

Future<void> flagsBottomSheet(
    {required BuildContext context,
    required VoidCallback onApply,
    required ValueChanged<int> onSelectLanguage,
    required List<MarketsType> activeLanguages,
    required AdvisorPreviewCubit advisorPreviewCubit}) async {
  showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => BlocProvider<AdvisorPreviewCubit>.value(
            value: advisorPreviewCubit,
            child: Container(
              decoration: const BoxDecoration(
                color: AdvisorPreviewConstants.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _FlagBottomSheetHeader(onApply: onApply),
                  Flexible(
                    child: Builder(builder: (context) {
                      final int selectedItemIndex = context.select(
                          (AdvisorPreviewCubit cubit) => cubit.state.oldIndex);
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: activeLanguages.length,
                          itemBuilder: (context, index) => _FlagTileWidget(
                              languageCode: activeLanguages[index],
                              isSelected: index == selectedItemIndex,
                              onTap: () => onSelectLanguage(index)));
                    }),
                  )
                ],
              ),
            ),
          ),
      backgroundColor: AdvisorPreviewConstants.white);
}

class _FlagBottomSheetHeader extends StatelessWidget {
  final VoidCallback? onApply;

  const _FlagBottomSheetHeader({Key? key, this.onApply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const EdgeInsets padding =
        EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0);
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
        onTap: Get.back,
        child: Padding(
          padding: padding,
          child: Text(S.of(context).cancel,
              style: AdvisorPreviewConstants.appBarTitleStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AdvisorPreviewConstants.primary)),
        ),
      ),
      GestureDetector(
        onTap: onApply,
        child: Padding(
          padding: padding,
          child: Text(S.of(context).done,
              style: AdvisorPreviewConstants.appBarTitleStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AdvisorPreviewConstants.primary)),
        ),
      )
    ]);
  }
}

class _FlagTileWidget extends StatelessWidget {
  final MarketsType languageCode;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FlagTileWidget(
      {Key? key,
      required this.languageCode,
      this.isSelected = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? AppColors.online.withOpacity(0.4)
                : AdvisorPreviewConstants.white,
            border: const Border(
                top: BorderSide(
                    color: AdvisorPreviewConstants.inactive1, width: 0.5))),
        padding: const EdgeInsets.symmetric(
            vertical: 20.0, horizontal: AppConstants.horizontalScreenPadding),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(languageCode.flagImagePath),
              const SizedBox(width: 8.0),
              Text(
                languageCode.languageName(context),
                style: AdvisorPreviewConstants.displayLarge
                    .copyWith(color: AdvisorPreviewConstants.secondary),
              ),
            ],
          ),
          if (isSelected) Assets.vectors.selectionCheck.svg()
        ]),
      ),
    );
  }
}
