import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/zodiac.dart';

class ChatConversationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final UserData userData;
  final VoidCallback? endChatButtonOnTap;

  const ChatConversationAppBar({
    Key? key,
   required this.userData,
    this.endChatButtonOnTap,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {

    final BaseBrand selectedBrand = ZodiacBrand();

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0.0,
      elevation: 0.0,
      title: Builder(builder: (context) {

        return SizedBox(
          height: AppConstants.appBarHeight,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // if (publicQuestionId != null &&
                //     questionStatus == ChatItemStatusType.taken)
                //   Padding(
                //     padding: const EdgeInsets.only(right: 2.0),
                //     child: AppIconButton(
                //       onTap: returnInQueueButtonOnTap,
                //       icon: Assets.vectors.arrowReturn.path,
                //     ),
                //   ),
                  AppIconButton(
                    icon: Assets.vectors.arrowLeft.path,
                    onTap: selectedBrand.context?.pop,
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
                        Text(
                          selectedBrand.name,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w200,
                            color: Theme.of(context).shadowColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                UserAvatar(
                  diameter: 32.0,
                  avatarUrl: userData.avatar,
                ),
              ],
            ),
          ),
        );
      }),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
