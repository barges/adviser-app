import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/data/models/enums/missed_message_action.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/zodiac_extensions.dart';

class MissedMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const MissedMessageWidget({Key? key, required this.chatMessageModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String? clientName = context.read<ChatCubit>().clientData.name;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 262.0,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              AppConstants.buttonRadius,
            ),
            color: theme.canvasColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (chatMessageModel.action != null &&
                      chatMessageModel.action != MissedMessageAction.none)
                    SvgPicture.asset(
                      chatMessageModel.action!.iconPath,
                      width: AppConstants.iconSize,
                      height: AppConstants.iconSize,
                      color: AppColors.error,
                    ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  if (chatMessageModel.action != null &&
                      chatMessageModel.action != MissedMessageAction.none)
                    Expanded(
                      child: Text(
                        chatMessageModel.action!
                            .getDescription(context, clientName ?? ''),
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: AppColors.error),
                      ),
                    )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (chatMessageModel.utc != null)
                    Text(
                      chatMessageModel.utc!.chatListTime,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.0,
                        color: theme.shadowColor,
                      ),
                    )
                ],
              ),
              const Divider(
                height: 17.0,
              ),
              GestureDetector(
                onTap: () => logger.d('On tap'),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        SZodiac.of(context).replyZodiac,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 15.0,
                          color: theme.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
