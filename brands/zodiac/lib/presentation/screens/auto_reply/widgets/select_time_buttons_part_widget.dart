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

    final (String, String, String) timeRecord =
        context.select((AutoReplyCubit cubit) {
      AutoReplyState state = cubit.state;

      return (state.time, state.timeFrom, state.timeTo);
    });

    final String? selectedMessage = context.select((AutoReplyCubit cubit) {
      AutoReplyState state = cubit.state;

      return state.messages
          ?.firstWhereOrNull((element) => element.id == state.selectedMessageId)
          ?.message;
    });

    if (selectedMessage?.contains(timeRecord.$1) == true) {
      return SelectTimeButtonWidget(
        title: timeRecord.$1 == AutoReplyConstants.time
            ? SZodiac.of(context).setTimeZodiac
            : timeRecord.$1,
        setTime: autoReplyCubit.setSingleTime,
      );
    } else if (selectedMessage?.contains(timeRecord.$2) == true &&
        selectedMessage?.contains(timeRecord.$3) == true) {
      return Row(
        children: [
          Expanded(
            child: SelectTimeButtonWidget(
              title: timeRecord.$2 == AutoReplyConstants.timeFrom
                  ? SZodiac.of(context).setTimeFromZodiac
                  : timeRecord.$2,
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
              title: timeRecord.$3 == AutoReplyConstants.timeTo
                  ? SZodiac.of(context).setTimeToZodiac
                  : timeRecord.$3,
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
