// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/locales_descriptions_part_widget.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/main_part_info_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ZodiacMainCubit zodiacMainCubit = context.read<ZodiacMainCubit>();
    return BlocProvider(
      create: (_) => EditProfileCubit(
        zodiacGetIt.get<ZodiacCachingManager>(),
        zodiacGetIt.get<ZodiacUserRepository>(),
      ),
      child: Builder(builder: (context) {
        final EditProfileCubit editProfileCubit =
            context.read<EditProfileCubit>();
        return WillPopScope(
          onWillPop: () async {
            if (editProfileCubit.needUpdateAccount) {
              zodiacMainCubit.updateAccount();
            }
            return true;
          },
          child: Scaffold(
            body: GestureDetector(
              onTap: FocusScope.of(context).unfocus,
              child: Builder(builder: (context) {
                final DetailedUserInfo? detailedUserInfo = context.select(
                    (EditProfileCubit cubit) => cubit.state.detailedUserInfo);
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    ScrollableAppBar(
                      title: SZodiac.of(context).editProfileZodiac,
                      needShowError: true,
                      actionOnClick: () async {
                       await confirmChanges(
                          context,
                          editProfileCubit,
                          zodiacMainCubit,
                        );
                      },
                      backOnTap: () {
                        if (editProfileCubit.needUpdateAccount) {
                          zodiacMainCubit.updateAccount();
                        }
                      },
                    ),
                    SliverToBoxAdapter(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MainPartInfoWidget(
                          detailedUserInfo: detailedUserInfo,
                        ),
                        if (detailedUserInfo?.locales?.isNotEmpty == true)
                          const LocalesDescriptionsPartWidget()
                      ],
                    )),
                  ],
                );
              }),
            ),
          ),
        );
      }),
    );
  }

  Future<void> confirmChanges(
    BuildContext context,
    EditProfileCubit editProfileCubit,
    ZodiacMainCubit zodiacMainCubit,
  ) async {
    final bool? isSaved = await editProfileCubit.saveInfo();
    logger.d(isSaved);

    if (isSaved == true) {
      final bool? isOk = await showOkCancelAlert(
        context: context,
        title: 'Save',
        description: 'Your changes are accepted and will be reviewed shortly.'
            ' You will be notified when it is completed',
        okText: 'Close',
        allowBarrierClick: false,
        isCancelEnabled: false,
      );
      if (isOk == true) {
        context.pop();
        zodiacMainCubit.updateAccount();
      }
    } else if (isSaved == false) {
      editProfileCubit.needUpdateAccount = true;
    }
  }
}
