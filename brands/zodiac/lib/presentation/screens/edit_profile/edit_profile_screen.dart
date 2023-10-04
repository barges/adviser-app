// ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/services/connectivity_service.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/edit_profile/brand_model.dart';
import 'package:zodiac/domain/repositories/zodiac_edit_profile_repository.dart';
import 'package:zodiac/domain/repositories/zodiac_user_repository.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/scrollable_appbar/scrollable_appbar.dart';
import 'package:zodiac/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:zodiac/presentation/screens/edit_profile/widgets/edit_profile_body_widget.dart';
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
        zodiacGetIt.get<ConnectivityService>(),
        zodiacGetIt.get<ZodiacEditProfileRepository>(),
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
                final bool canRefresh = context
                    .select((EditProfileCubit cubit) => cubit.state.canRefresh);

                return RefreshIndicator(
                  onRefresh: editProfileCubit.getData,
                  notificationPredicate: (_) => canRefresh,
                  edgeOffset: (AppConstants.appBarHeight * 2) +
                      MediaQuery.of(context).padding.top,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      ScrollableAppBar(
                        title: SZodiac.of(context).editProfileZodiac,
                        needShowError: true,
                        actionOnClick: () async {
                          await _confirmChanges(
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
                        child: Builder(builder: (context) {
                          final List<BrandModel>? brands = context.select(
                              (EditProfileCubit cubit) => cubit.state.brands);
                          final int selectedBrandIndex = context.select(
                              (EditProfileCubit cubit) =>
                                  cubit.state.selectedBrandIndex);
                          if (brands != null) {
                            return IndexedStack(
                              index: selectedBrandIndex,
                              children: brands
                                  .mapIndexed(
                                    (i, e) => EditProfileBodyWidget(
                                      brands: brands,
                                      brandIndex: i,
                                    ),
                                  )
                                  .toList(),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _confirmChanges(
    BuildContext context,
    EditProfileCubit editProfileCubit,
    ZodiacMainCubit zodiacMainCubit,
  ) async {
    final bool? isSaved = false; // await editProfileCubit.saveInfo();

    if (isSaved == true) {
      final bool? isOk = await showOkCancelAlert(
        context: context,
        title: SZodiac.of(context).saveZodiac,
        description: SZodiac.of(context)
            .yourChangesAreAcceptedAndWillBeReviewedShortlyZodiac,
        okText: SZodiac.of(context).closeZodiac,
        allowBarrierClick: false,
        isCancelEnabled: false,
      );
      if (isOk == true) {
        context.pop();
        zodiacMainCubit.updateAccount();
      }
    } else if (isSaved == false) {
      editProfileCubit.needUpdateAccount = true;
    } else {
      context.pop();
      if (editProfileCubit.needUpdateAccount) {
        zodiacMainCubit.updateAccount();
      }
    }
  }
}
