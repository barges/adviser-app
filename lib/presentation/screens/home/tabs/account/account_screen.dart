import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/change_locale_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/drawer/app_drawer.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountCubit(),
      child: Builder(builder: (context) {
        final AccountCubit accountCubit = context.read<AccountCubit>();
        final HomeCubit homeCubit = context.read<HomeCubit>();

        return Scaffold(
          key: accountCubit.scaffoldKey,
          drawer: const AppDrawer(),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 84.0,
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32.0,
                      left: AppConstants.horizontalScreenPadding,
                      right: AppConstants.horizontalScreenPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(builder: (context) {
                        final Brand currentBrand = context.select(
                            (MainCubit cubit) => cubit.state.currentBrand);
                        return InkWell(
                          onTap: homeCubit.openDrawer,
                          child: Row(
                            children: [
                              Container(
                                height: 32.0,
                                width: 32.0,
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.buttonRadius),
                                  color: Get.theme.scaffoldBackgroundColor,
                                ),
                                child: SvgPicture.asset(currentBrand.icon),
                              ),
                              const SizedBox(width: 8.0),
                              Text(currentBrand.name,
                                  style: Get.textTheme.headlineMedium)
                            ],
                          ),
                        );
                      }),
                      const ChangeLocaleButton()
                    ],
                  ),
                ),
              )),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                    color: Get.theme.canvasColor),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(
                        AppConstants.horizontalScreenPadding),
                    child: Row(
                      children: [
                        const UserAvatar(
                            avatarUrl:
                                'https://img.freepik.com/free-vector/cute-astronaut-dance-cartoon-vector-icon-illustration-technology-science-icon-concept-isolated-premium-vector-flat-cartoon-style_138676-3851.jpg',
                            diameter: 72.0,
                            isOnline: true),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Psychic Sherman',
                                overflow: TextOverflow.ellipsis,
                                style: Get.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text('Life Coach, Tarot, Reiki, sdfsdf, sdffsdf',
                                  overflow: TextOverflow.ellipsis,
                                  style: Get.textTheme.bodyMedium
                                      ?.copyWith(color: Get.theme.shadowColor))
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Assets.vectors.arrowLeft.svg())
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppConstants.horizontalScreenPadding),
                    child: Column(children: [
                      const SizedBox(height: 2, child: Divider()),
                      Builder(
                        builder: (context) {
                          final bool isAvailable = context.select(
                              (AccountCubit cubit) => cubit.state.isAvailable);
                          return CustomTileWithCheckButtonWidget(
                            value: isAvailable,
                            title: S.of(context).imAvailableNow,
                            iconSVGPath: Assets.vectors.availability.path,
                            onChanged: accountCubit.updateIsAvailableValue,
                          );
                        },
                      ),
                      const SizedBox(height: 2, child: Divider()),
                      Builder(
                        builder: (context) {
                          final bool enableNotifications = context.select(
                              (AccountCubit cubit) =>
                                  cubit.state.enableNotifications);
                          return CustomTileWithCheckButtonWidget(
                            value: enableNotifications,
                            title: S.of(context).notifications,
                            iconSVGPath: Assets.vectors.notification.path,
                            onChanged:
                                accountCubit.updateEnableNotificationsValue,
                          );
                        },
                      ),
                      const SizedBox(height: 2, child: Divider()),
                      CustomTileWidget(
                        iconSVGPath: Assets.vectors.eye.path,
                        title: S.of(context).previewAccount,
                      )
                    ]),
                  )
                ]),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 24.0),
                padding: const EdgeInsets.only(
                    left: AppConstants.horizontalScreenPadding),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                    color: Get.theme.canvasColor),
                child: Column(children: [
                  CustomTileWidget(
                    title: S.of(context).reviews,
                    iconSVGPath: Assets.vectors.starActive.path,
                    widget: Row(children: [
                      RatingBar(
                        initialRating: 3,
                        direction: Axis.horizontal,
                        itemSize: 18,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Assets.vectors.starFilled.svg(),
                          half: Assets.vectors.starEmpty.svg(),
                          empty: Assets.vectors.starEmpty.svg(),
                        ),
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 1.0),
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(width: 9.0),
                      Text(
                        "999",
                        style: Get.textTheme.bodySmall
                            ?.copyWith(color: Get.theme.shadowColor),
                      ),
                      Text(
                        " +25",
                        style: Get.textTheme.bodySmall
                            ?.copyWith(color: AppColors.online),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 2, child: Divider()),
                  CustomTileWidget(
                    title: S.of(context).balanceTransactions,
                    iconSVGPath: Assets.vectors.transactions.path,
                    widget: Row(children: [
                      Text(
                        "999",
                        style: Get.textTheme.bodySmall
                            ?.copyWith(color: Get.theme.shadowColor),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 2, child: Divider()),
                  CustomTileWidget(
                    title: S.of(context).settings,
                    iconSVGPath: Assets.vectors.settings.path,
                  )
                ]),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 96.0,
                    decoration: BoxDecoration(
                        color: Get.theme.canvasColor,
                        borderRadius:
                            BorderRadius.circular(AppConstants.buttonRadius)),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  14.0, 12.0, 10.0, 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .notEnoughConversationsCheckOurProfileGuide,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Get.textTheme.bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    S.of(context).seeMore,
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Get.theme.primaryColor,
                                        decoration: TextDecoration.underline),
                                  )
                                ],
                              ),
                            )),
                        Flexible(
                            flex: 6,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(
                                      AppConstants.buttonRadius),
                                  bottomRight: Radius.circular(
                                      AppConstants.buttonRadius)),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Assets.images.conversations
                                      .image(fit: BoxFit.fill)),
                            ))
                      ],
                    )),
              )
            ]),
          ),
        );
      }),
    );
  }
}

class CustomTileWidget extends StatelessWidget {
  final String iconSVGPath;
  final String title;
  final Widget? widget;

  const CustomTileWidget(
      {Key? key, required this.title, required this.iconSVGPath, this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            SvgPicture.asset(iconSVGPath),
            const SizedBox(width: 10.0),
            Text(title, style: Get.textTheme.bodyMedium),
          ],
        ),
        Row(
          children: [
            widget ?? const SizedBox(),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding),
                child: Assets.vectors.arrowLeft.svg()),
          ],
        )
      ]),
    );
  }
}

class CustomTileWithCheckButtonWidget extends StatelessWidget {
  final String iconSVGPath;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomTileWithCheckButtonWidget(
      {Key? key,
      required this.value,
      required this.title,
      required this.iconSVGPath,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            SvgPicture.asset(iconSVGPath),
            const SizedBox(width: 10.0),
            Text(title, style: Get.textTheme.bodyMedium),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding - 4),
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: Get.theme.primaryColor,
            trackColor: Get.theme.hintColor,
          ),
        )
      ]),
    );
  }
}
