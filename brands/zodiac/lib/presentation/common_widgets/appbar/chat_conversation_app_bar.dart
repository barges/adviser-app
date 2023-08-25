import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/data/models/enums/chat_payment_status.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/zodiac.dart';
import 'package:zodiac/zodiac_extensions.dart';

class ChatConversationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final UserData userData;
  final VoidCallback? endChatButtonOnTap;
  final VoidCallback? backButtonOnTap;
  final VoidCallback? onTap;

  const ChatConversationAppBar({
    Key? key,
    required this.userData,
    this.endChatButtonOnTap,
    this.onTap,
    this.backButtonOnTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final BaseBrand selectedBrand = ZodiacBrand();

    final ZodiacUserStatus? clientStatus = context
        .select((ChatCubit cubit) => cubit.state.clientInformation?.status);

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0.0,
      elevation: 0.0,
      title: Builder(builder: (context) {
        return GestureDetector(
          onTap: onTap,
          child: SizedBox(
            height: AppConstants.appBarHeight,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScreenPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (endChatButtonOnTap != null)
                    AppIconButton(
                      icon: Assets.zodiac.vectors.endChat.path,
                      onTap: endChatButtonOnTap,
                      color: AppColors.error,
                    )
                  else
                    AppIconButton(
                      icon: Assets.vectors.arrowLeft.path,
                      onTap: backButtonOnTap ?? selectedBrand.context?.pop,
                    ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 12.0),
                              SvgPicture.asset(
                                selectedBrand.iconPath,
                                height: 17.0,
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  userData.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Builder(builder: (context) {
                          final Duration? timerValue = context.select(
                              (ChatCubit cubit) => cubit.state.chatTimerValue);

                          final bool isChatReconnecting = context.select(
                              (ChatCubit cubit) =>
                                  cubit.state.isChatReconnecting);

                          final ChatPaymentStatus? chatPaymentStatus =
                              context.select((ChatCubit cubit) =>
                                  cubit.state.chatPaymentStatus);

                          final bool internetConnectionIsAvailable =
                              context.select((MainCubit cubit) =>
                                  cubit.state.internetConnectionIsAvailable);

                          if (isChatReconnecting ||
                              !internetConnectionIsAvailable) {
                            return Text(
                              SZodiac.of(context).reconnectingZodiac,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).shadowColor,
                              ),
                            );
                          } else if (timerValue != null) {
                            return Text(
                              '${chatPaymentStatus?.getLabel(context) ?? ''} ${timerValue.chatTimerFormat}',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).shadowColor,
                              ),
                            );
                          } else if (clientStatus != null) {
                            return Text(
                              clientStatus.statusText(context),
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).shadowColor,
                              ),
                            );
                          } else {
                            return Text(
                              selectedBrand.name,
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w200,
                                color: Theme.of(context).shadowColor,
                              ),
                            );
                          }
                        })
                      ],
                    ),
                  ),
                  UserAvatar(
                    diameter: 32.0,
                    avatarUrl: userData.avatar,
                    badgeColor: clientStatus?.statusBadgeColor(context),
                    badgeDiameter: 12.0,
                    badgeBorderWidth: 2.0,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
