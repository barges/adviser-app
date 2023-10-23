import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/common_widgets/radio_button_widget.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_cubit.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_state.dart';

class AutoReplyListItemWidget extends StatelessWidget {
  final String message;
  final int? id;

  const AutoReplyListItemWidget({
    Key? key,
    required this.message,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final AutoReplyCubit autoReplyCubit = context.read<AutoReplyCubit>();

    final int? selectedMessageId =
        context.select((AutoReplyCubit cubit) => cubit.state.selectedMessageId);

    final bool isSelected = selectedMessageId == id;

    final Color borderColor = isSelected ? theme.primaryColor : theme.hintColor;

    final ({String time, String timeFrom, String timeTo}) timeRecord =
        context.select((AutoReplyCubit cubit) {
      AutoReplyState state = cubit.state;

      return (time: state.time, timeFrom: state.timeFrom, timeTo: state.timeTo);
    });
    final List<String> splittedMessage =
        _splitMessage(timeRecord, autoReplyCubit);

    return GestureDetector(
      onTap: () => autoReplyCubit.selectMessage(id),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.canvasColor,
                borderRadius: BorderRadius.circular(12.0),
                border: Border(
                  top: BorderSide(
                    color: borderColor,
                  ),
                  right: BorderSide(
                    color: borderColor,
                  ),
                  left: BorderSide(
                    color: borderColor,
                  ),
                  bottom: BorderSide(
                    color: borderColor,
                    width: 3.0,
                  ),
                ),
              ),
              child: RichText(
                  text: TextSpan(
                      children: splittedMessage
                          .map((e) => TextSpan(
                              text: e,
                              style: _getTextSpanStyle(theme, e, timeRecord)))
                          .toList())),
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          RadioButtonWidget(
            isSelected: isSelected,
          )
        ],
      ),
    );
  }

  List<String> _splitMessage(
      ({String time, String timeFrom, String timeTo}) record,
      AutoReplyCubit autoReplyCubit) {
    final String time = record.time;
    final String timeFrom = record.timeFrom;
    final String timeTo = record.timeTo;

    final List<String> splittedMessage = [];
    if (autoReplyCubit.isSingleTimeMessage(message)) {
      final int timeIndex = message.indexOf(time);

      splittedMessage.add(message.substring(0, timeIndex));
      splittedMessage.add(time);
      splittedMessage.add(message.substring(timeIndex + time.length));
    }

    if (autoReplyCubit.isMultiTimeMessage(message)) {
      final int timeFromIndex = message.indexOf(timeFrom);
      final int timeToIndex = message.indexOf(timeTo);

      splittedMessage.add(message.substring(0, timeFromIndex));
      splittedMessage.add(timeFrom);
      splittedMessage
          .add(message.substring(timeFromIndex + timeFrom.length, timeToIndex));
      splittedMessage.add(timeTo);
      splittedMessage.add(message.substring(timeToIndex + timeTo.length));
    }

    return splittedMessage;
  }

  TextStyle? _getTextSpanStyle(ThemeData theme, String text,
      ({String time, String timeFrom, String timeTo}) timeRecord) {
    final bool textIsTime = text == timeRecord.time ||
        text == timeRecord.timeFrom ||
        text == timeRecord.timeTo;

    return theme.textTheme.bodyMedium
        ?.copyWith(color: textIsTime ? theme.primaryColor : theme.hoverColor);
  }
}
