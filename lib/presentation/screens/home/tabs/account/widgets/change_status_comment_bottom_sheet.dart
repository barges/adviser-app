import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';

Future<void> changeStatusCommentBottomSheet({
  required BuildContext context,
  required TextEditingController commentController,
  required VoidCallback okOnTap,
}) async {
  Get.bottomSheet(
      BlocProvider.value(
        value: context.read<AccountCubit>(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 108.0,
                  ),
                  height: 4.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.0),
                    color: Get.theme.hintColor,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  S.of(context).areYouSureThatYouWantToChangeYourStatus,
                  style: Get.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Builder(builder: (context) {
                  context.select(
                      (AccountCubit cubit) => cubit.state.commentHasFocus);
                  return AppTextField(
                    isBig: true,
                    focusNode: context.read<AccountCubit>().commentNode,
                    label: S.of(context).informOurTeamYourPlannedReturnDate,
                    controller: commentController,
                  );
                }),
                const SizedBox(
                  height: 24.0,
                ),
                Builder(builder: (context) {
                  final bool isActive = context.select((AccountCubit cubit) =>
                      cubit.state.commentButtonIsActive);
                  return AppElevatedButton(
                    title: S.of(context).yesImSure,
                    onPressed: isActive
                        ? () {
                            Get.back();
                            okOnTap();
                          }
                        : null,
                  );
                }),
                CupertinoButton(
                  onPressed: Get.back,
                  child: Text(
                    S.of(context).noIChangedMyMind,
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Get.theme.canvasColor,
      isScrollControlled: true);
}
