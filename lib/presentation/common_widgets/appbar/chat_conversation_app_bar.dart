import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/enums/chat_item_status_type.dart';
import 'package:shared_advisor_interface/data/models/enums/zodiac_sign.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (publicQuestionId != null &&
                  questionStatus == ChatItemStatusType.taken)
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: _ReturnInQueue(
                    onTap: returnInQueueButtonOnTap,
                  ),
                ),
              if (questionStatus != ChatItemStatusType.taken)
                AppIconButton(
                  icon: Assets.vectors.arrowLeft.path,
                  onTap: Get.back,
                ),
              Builder(builder: (context) {
                final Brand selectedBrand = context
                    .select((MainCubit cubit) => cubit.state.currentBrand);
                return Expanded(
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
                                    selectedBrand.icon,
                                    height: 17.0,
                                  ),
                                  const SizedBox(width: 12.0),
                                  Expanded(
                                    child: Text(
                                      title ?? S.of(context).notSpecified,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16.0,
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
                );
              }),
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
        );
      }),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}

class _ReturnInQueue extends StatelessWidget {
  final VoidCallback? onTap;

  const _ReturnInQueue({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AppIconButton(
            icon: Assets.vectors.close.path,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            S.of(context).returnToQueue.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12.0,
                ),
          ),
        ],
      ),
    );
  }
}
