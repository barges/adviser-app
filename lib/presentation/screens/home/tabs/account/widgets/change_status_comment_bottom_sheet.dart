import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/text_fields/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';

Future<void> changeStatusCommentBottomSheet(
    {required BuildContext context,
    required TextEditingController commentController,
    required VoidCallback okOnTap,
    required AccountCubit accountCubit}) async {
  showModalBottomSheet(
      context: context,
      builder: (context) => BlocProvider.value(
            value: accountCubit,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding,
                ),
                child: SingleChildScrollView(
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
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        S.of(context).areYouSureThatYouWantToChangeYourStatus,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(
                            AppConstants.buttonRadius,
                          ),
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Assets.vectors.info.svg(
                                height: 18.0,
                                width: 18.0,
                                color: Theme.of(context).shadowColor,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    S
                                        .of(context)
                                        .youWillBeAbleToChangeYourStatusBackIn,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12.0,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Builder(builder: (context) {
                        context.select((AccountCubit cubit) =>
                            cubit.state.commentHasFocus);
                        return AppTextField(
                          isBig: true,
                          focusNode: context.read<AccountCubit>().commentNode,
                          label: S.of(context).tellOurTeamWhenYouPlanToReturn,
                          controller: commentController,
                        );
                      }),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Builder(builder: (context) {
                        final bool isActive = context.select(
                            (AccountCubit cubit) =>
                                cubit.state.commentButtonIsActive);
                        return AppElevatedButton(
                          title: S.of(context).yesImSure,
                          onPressed: isActive
                              ? () {
                                  Navigator.pop(context);
                                  okOnTap();
                                }
                              : null,
                        );
                      }),
                      CupertinoButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          S.of(context).noIChangedMyMind,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      backgroundColor: Theme.of(context).canvasColor,
      isScrollControlled: true);
}
