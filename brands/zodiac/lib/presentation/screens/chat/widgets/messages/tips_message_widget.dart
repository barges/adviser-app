import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

class TipsMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const TipsMessageWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        color: theme.canvasColor,
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.zodiac.dollarIcon.svg(
            height: AppConstants.iconSize,
            width: AppConstants.iconSize,
            color: theme.primaryColor,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(chatMessageModel.message ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.0))
        ],
      ),
    );
  }
}
