import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../infrastructure/routing/app_router.dart';
import '../../../app_constants.dart';
import '../../../data/models/enums/chat_item_status_type.dart';
import '../../../data/models/enums/zodiac_sign.dart';
import '../../../generated/assets/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../screens/chat/chat_cubit.dart';
import '../buttons/app_icon_button.dart';

class ChatConversationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final ZodiacSign? zodiacSign;
  final VoidCallback? returnInQueueButtonOnTap;
  final String? publicQuestionId;

  const ChatConversationAppBar({
    Key? key,
    this.title,
    this.zodiacSign,
    this.returnInQueueButtonOnTap,
    this.publicQuestionId,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    // TODO DELETE
    //final BaseBrand selectedBrand = FortunicaBrand();

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: 0.0,
      elevation: 0.0,
      title: Builder(builder: (context) {
        final ChatItemStatusType? questionStatus = returnInQueueButtonOnTap !=
                null
            ? context.select((ChatCubit cubit) => cubit.state.questionStatus) ??
                ChatItemStatusType.open
            : null;
        return SizedBox(
          height: AppConstants.appBarHeight,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (publicQuestionId != null &&
                    questionStatus == ChatItemStatusType.taken)
                  Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: AppIconButton(
                      onTap: returnInQueueButtonOnTap,
                      icon: Assets.vectors.arrowReturn.path,
                    ),
                  ),
                if (questionStatus != ChatItemStatusType.taken)
                  AppIconButton(
                    icon: Assets.vectors.arrowLeft.path,
                    onTap: currentContext?.pop,
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
                              Assets.vectors.fortunica.path,
                              height: 17.0,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                title ??
                                    SFortunica.of(context)
                                        .notSpecifiedFortunica,
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
                      // TODO DELETE
                      Text(
                        AppConstants.fortunicaName,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).shadowColor,
                        ),
                      ),
                    ],
                  ),
                ),
                // if (publicQuestionId != null &&
                //     questionStatus == ChatItemStatusType.taken)
                //   const Spacer(),
                if (zodiacSign != null)
                  SvgPicture.asset(
                    zodiacSign!.imagePath(context),
                    width: 28.0,
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
