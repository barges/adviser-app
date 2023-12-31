import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/data/models/chats/rirual_card_info.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';

class RitualInfoCardWidget extends StatelessWidget {
  final RitualCardInfo? ritualCardInfo;

  const RitualInfoCardWidget({super.key, required this.ritualCardInfo});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isLeftImage = ritualCardInfo?.leftImage != null;
    final isRightImage = ritualCardInfo?.rightImage != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        border: Border.all(
          width: 1.0,
          color: theme.hintColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                S.of(context).personalDetails,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.shadowColor,
                  fontSize: 13.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                ritualCardInfo?.name ?? '',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.hoverColor,
                  fontSize: 17.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat(datePattern1)
                      .format(ritualCardInfo?.birthdate ?? DateTime.now()),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.shadowColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 4.0,
                    width: 4.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.hintColor,
                    ),
                  ),
                ),
                Text(
                  ritualCardInfo?.gender?.name(context) ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.shadowColor,
                  ),
                ),
              ],
            ),
            if (isLeftImage || isRightImage)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLeftImage)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (ritualCardInfo?.leftImageTitle != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                ritualCardInfo!.leftImageTitle!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.shadowColor,
                                ),
                              ),
                            ),
                          _RitualInfoCardImageWidget(
                            ritualCardInfo: ritualCardInfo!,
                            ritualInfoCardImage: _RitualInfoCardImage.left,
                          ),
                        ],
                      ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    if (isRightImage)
                      Column(
                        children: [
                          if (ritualCardInfo?.rightImageTitle != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                ritualCardInfo!.rightImageTitle!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.shadowColor,
                                ),
                              ),
                            ),
                          _RitualInfoCardImageWidget(
                            ritualCardInfo: ritualCardInfo!,
                            ritualInfoCardImage: _RitualInfoCardImage.right,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RitualInfoCardImageWidget extends StatelessWidget {
  final RitualCardInfo ritualCardInfo;
  final _RitualInfoCardImage ritualInfoCardImage;

  const _RitualInfoCardImageWidget({
    Key? key,
    required this.ritualCardInfo,
    required this.ritualInfoCardImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return GestureDetector(
      onTap: () {
        chatCubit.goToGallery(ritualCardInfo, ritualInfoCardImage.value);
      },
      child: AppImageWidget(
        uri: Uri.parse(ritualInfoCardImage.getImageUrl(ritualCardInfo)),
        width: 132.0,
        height: 132.0,
        memCacheHeight: 132,
        radius: 8.0,
      ),
    );
  }
}

enum _RitualInfoCardImage {
  left(0.0),
  right(1.0);

  final double value;

  const _RitualInfoCardImage(this.value);

  String getImageUrl(RitualCardInfo ritualCardInfo) {
    switch (this) {
      case _RitualInfoCardImage.right:
        return ritualCardInfo.rightImage ?? '';
      case _RitualInfoCardImage.left:
        return ritualCardInfo.leftImage ?? '';
    }
  }
}
