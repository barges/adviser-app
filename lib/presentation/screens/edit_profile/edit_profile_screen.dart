import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_loading_indicator.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_text_field.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/edit_profile_state.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/gallery_images.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/languages_section_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/edit_profile/widgets/profile_image_widget.dart';

const double maxHeight = 104.0;
const double minHeight = 52.0;

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Get.put<EditProfileCubit>(EditProfileCubit()),
      child: Builder(builder: (context) {
        final EditProfileCubit editProfileCubit =
            context.read<EditProfileCubit>();
        return BlocListener<EditProfileCubit, EditProfileState>(
          listener: (prev, current) {
            if (current.chosenLanguageIndex == 0) {
              editProfileCubit.languagesScrollController.animateTo(
                  editProfileCubit
                      .languagesScrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            } else if (current.chosenLanguageIndex ==
                editProfileCubit.activeLanguages.length - 1) {
              editProfileCubit.languagesScrollController.animateTo(
                  editProfileCubit
                      .languagesScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear);
            }
          },
          child: Builder(builder: (context) {
            return Stack(
              children: [
                Scaffold(
                  key: editProfileCubit.scaffoldKey,
                  drawer: const AppDrawer(),
                  body: SafeArea(
                    top: false,
                    child: CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        Builder(builder: (context) {
                          final bool isWide = context.select(
                              (EditProfileCubit cubit) =>
                                  cubit.state.isWideAppBar);
                          return AppSliverAppBar(
                            setIsWideValue: (value) {
                              editProfileCubit.setIsWideAppbar(value);
                            },
                            isWide: isWide,
                            actionOnClick: () =>
                                editProfileCubit.updateUserInfo(),
                            openDrawer: editProfileCubit.openDrawer,
                          );
                        }),
                        SliverToBoxAdapter(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: Column(
                              children: [
                                const ProfileImageWidget(),
                                const SizedBox(
                                  height: 16.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: AppConstants
                                              .horizontalScreenPadding),
                                      child: Builder(builder: (context) {
                                        final String nicknameErrorText = context
                                            .select((EditProfileCubit cubit) =>
                                                cubit.state.nicknameErrorText);
                                        return AppTextField(
                                          controller: editProfileCubit
                                              .nicknameController,
                                          label: S.of(context).nickname,
                                          errorText: nicknameErrorText,
                                        );
                                      }),
                                    ),
                                    const LanguageSectionWidget(),
                                    const SizedBox(
                                      height: 24.0,
                                    ),
                                    const GalleryImages(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    final bool isLoading = context.select(
                        (EditProfileCubit cubit) => cubit.state.isLoading);
                    return AppLoadingIndicator(
                      showIndicator: isLoading,
                    );
                  },
                ),
              ],
            );
          }),
        );
      }),
    );
  }
}

class AppSliverAppBar extends StatelessWidget {
  final VoidCallback? actionOnClick;
  final bool isWide;
  final VoidCallback? openDrawer;
  final ValueChanged<bool> setIsWideValue;

  const AppSliverAppBar({
    Key? key,
    required this.setIsWideValue,
    required this.isWide,
    this.actionOnClick,
    this.openDrawer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      forceElevated: true,
      backgroundColor: Get.theme.canvasColor,
      expandedHeight: 104.0,
      centerTitle: true,
      pinned: true,
      snap: true,
      floating: true,
      titleSpacing: 16.0,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        setIsWideValue(
            constraints.maxHeight - MediaQuery.of(context).padding.top >
                    maxHeight - 1.0 &&
                constraints.maxHeight - MediaQuery.of(context).padding.top <=
                    maxHeight);

        return FlexibleSpaceBar(
          expandedTitleScale: 1,
          titlePadding: const EdgeInsets.all(16.0),
          title: Builder(
            builder: (context) {
              return SizedBox(
                height: 104.0,
                child: Builder(builder: (context) {
                  return isWide
                      ? ConstrainedBox(
                          constraints: BoxConstraints(minWidth: Get.width),
                          child: Row(
                            children: [
                              AppIconButton(
                                icon: Assets.vectors.arrowLeft.path,
                                onTap: Get.back,
                              ),
                              Builder(builder: (context) {
                                final Brand currentBrand = context.select(
                                    (MainCubit cubit) =>
                                        cubit.state.currentBrand);
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: openDrawer,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: AppConstants.iconSize,
                                          width: AppConstants.iconSize,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0),
                                          margin: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 4.0,
                                          ),
                                          child: SvgPicture.asset(
                                            currentBrand.icon,
                                          ),
                                        ),
                                        Text(currentBrand.name,
                                            style: Get.textTheme.labelMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Get
                                                        .theme.primaryColor)),
                                        const SizedBox(width: 4.0),
                                        Assets.vectors.swap.svg(
                                          color: Get.theme.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              AppIconButton(
                                icon: Assets.vectors.check.path,
                                onTap: () {
                                  if (actionOnClick != null) {
                                    actionOnClick!();
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink();
                }),
              );
            },
          ),
        );
      }),
      //title:
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52.0),
        child: Builder(
          builder: (context) {
            final Brand currentBrand =
                context.select((MainCubit cubit) => cubit.state.currentBrand);
            return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 52,
                child: !isWide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppIconButton(
                            icon: Assets.vectors.arrowLeft.path,
                            onTap: Get.back,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: AppConstants.iconSize,
                                    width: AppConstants.iconSize,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: SvgPicture.asset(
                                      currentBrand.icon,
                                    ),
                                  ),
                                  Text(
                                    S.of(context).editProfile,
                                    style:
                                        Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17.0,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                currentBrand.name,
                                style: Get.textTheme.bodySmall?.copyWith(
                                  fontSize: 12.0,
                                  color: Get.iconColor,
                                ),
                              ),
                            ],
                          ),
                          AppIconButton(
                            icon: Assets.vectors.check.path,
                            onTap: () {
                              if (actionOnClick != null) {
                                actionOnClick!();
                              }
                            },
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Text(
                            S.of(context).editProfile,
                            style: Get.textTheme.headlineMedium,
                          ),
                        ],
                      ));
          },
        ),
      ),
    );
  }
}
