import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/tile_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';

class UserInfoPartWidget extends StatelessWidget {
  const UserInfoPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ZodiacAccountCubit zodiacAccountCubit =
        context.read<ZodiacAccountCubit>();
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Theme.of(context).canvasColor,
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 0.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      right: AppConstants.horizontalScreenPadding),
                  child: _UserInfoWidget(),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Divider(
                  height: 1.0,
                ),
                Builder(builder: (context) {
                  final bool userOnline = context.select(
                      (ZodiacAccountCubit cubit) =>
                          cubit.state.userStatusOnline);
                  return TileWidget(
                    ///TODO: need translate
                    title: 'I\'m available now',
                    iconSVGPath: Assets.vectors.availability.path,
                    initSwitcherValue: userOnline,
                    onChanged: zodiacAccountCubit.updateUserStatus,
                  );
                }),
                const Divider(
                  height: 1.0,
                ),
                TileWidget(
                  ///TODO: need translate
                  title: 'Preview account',
                  iconSVGPath: Assets.vectors.eye.path,
                  onTap: () {},
                ),
              ],
            )));
  }
}

class _UserInfoWidget extends StatelessWidget {
  const _UserInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final UserDetails? userInfo =
        context.select((ZodiacAccountCubit cubit) => cubit.state.userInfo);
    final bool userOnline = context
        .select((ZodiacAccountCubit cubit) => cubit.state.userStatusOnline);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserAvatar(
          avatarUrl: userInfo?.avatar,
          diameter: 72.0,
          badgeColor: userOnline ? AppColors.online : theme.shadowColor,
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 17.0,
                ),
              ),
              Text(
                userInfo?.specializing ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.shadowColor,
                ),
              ),
            ],
          ),
        ),
        Assets.vectors.arrowRight.svg(
          width: AppConstants.iconSize,
          height: AppConstants.iconSize,
        )
      ],
    );
  }
}
