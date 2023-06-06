import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

class SystemMessageWidget extends StatelessWidget {
  final ChatMessageModel chatMessageModel;

  const SystemMessageWidget({
    Key? key,
    required this.chatMessageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppConstants.buttonRadius,
        ),
        color: theme.canvasColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.zodiac.vectors.infoSquareIcon.svg(
            height: 18.0,
            width: 18.0,
            color: AppColors.orange,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Text(
              parse(chatMessageModel.message).body?.text ?? '',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.orange,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
