import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/replied_message_content_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/chat_text_input_widget.dart';

class RepliedMessageWidget extends StatelessWidget {
  final ChatMessageModel repliedMessage;

  const RepliedMessageWidget({
    Key? key,
    required this.repliedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return GestureDetector(
      onTap: () {
        Utils.animateToWidget(
          chatCubit.repliedMessageGlobalKey,
          alignment: 0.7,
        );
      },
      child: Container(
        height: repliedMessageHeight,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 6.0,
        ),
        decoration: BoxDecoration(
          color: theme.canvasColor,
        ),
        child: Row(
          children: [
            Assets.zodiac.vectors.arrowReply.svg(
              height: AppConstants.iconSize,
              width: AppConstants.iconSize,
              colorFilter: ColorFilter.mode(
                theme.primaryColor,
                BlendMode.srcIn,
              ),
            ),
            VerticalDivider(
              width: 24.0,
              thickness: 2.0,
              color: theme.primaryColor,
            ),
            Expanded(
                child: RepliedMessageContentWidget(
              repliedMessage: repliedMessage,
            )),
            const SizedBox(
              width: 8.0,
            ),
            GestureDetector(
              onTap: () {
                chatCubit.setRepliedMessage();
              },
              child: Assets.vectors.close.svg(
                height: AppConstants.iconSize,
                width: AppConstants.iconSize,
                colorFilter: ColorFilter.mode(
                  theme.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
