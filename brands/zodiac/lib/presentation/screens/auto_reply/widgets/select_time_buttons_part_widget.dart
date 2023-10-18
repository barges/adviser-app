import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_constants.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_cubit.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_state.dart';
import 'package:zodiac/presentation/screens/auto_reply/widgets/select_time_button_widget.dart';

class SelectTimeButtonsPartWidget extends StatefulWidget {
  const SelectTimeButtonsPartWidget({Key? key}) : super(key: key);

  @override
  State<SelectTimeButtonsPartWidget> createState() =>
      _SelectTimeButtonsPartWidgetState();
}

class _SelectTimeButtonsPartWidgetState
    extends State<SelectTimeButtonsPartWidget> {
  final PublishSubject openTimeToPicker = PublishSubject();

  @override
  void dispose() {
    openTimeToPicker.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AutoReplyCubit autoReplyCubit = context.read<AutoReplyCubit>();

    final ({String time, String timeFrom, String timeTo}) timeRecord =
        context.select((AutoReplyCubit cubit) {
      AutoReplyState state = cubit.state;

      return (time: state.time, timeFrom: state.timeFrom, timeTo: state.timeTo);
    });

    final String? selectedMessage = context.select((AutoReplyCubit cubit) {
      AutoReplyState state = cubit.state;

      return state.messages
          ?.firstWhereOrNull((element) => element.id == state.selectedMessageId)
          ?.message;
    });

    if (autoReplyCubit.isSingleTimeMessage(selectedMessage)) {
      return SelectTimeButtonWidget(
        title: timeRecord.time == AutoReplyConstants.time
            ? SZodiac.of(context).setTimeZodiac
            : timeRecord.time,
        setTime: autoReplyCubit.setSingleTime,
      );
    } else if (autoReplyCubit.isMultiTimeMessage(selectedMessage)) {
      return Row(
        children: [
          Expanded(
            child: SelectTimeButtonWidget(
              title: timeRecord.timeFrom == AutoReplyConstants.timeFrom
                  ? SZodiac.of(context).setTimeFromZodiac
                  : timeRecord.timeFrom,
              setTime: (time) {
                autoReplyCubit.setTimeFrom(time);
                openTimeToPicker.add(true);
              },
            ),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: SelectTimeButtonWidget(
              title: timeRecord.timeTo == AutoReplyConstants.timeTo
                  ? SZodiac.of(context).setTimeToZodiac
                  : timeRecord.timeTo,
              setTime: autoReplyCubit.setTimeTo,
              openPickerStream: openTimeToPicker.stream,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
