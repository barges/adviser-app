import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/audio_players/chat_recorded_player_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recording_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';

class ActiveChatInputFieldWidget extends StatelessWidget {
  const ActiveChatInputFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final bool isRecordingAudio =
        context.select((ChatCubit cubit) => cubit.state.isRecordingAudio);
    final bool isAudioFileSaved =
        context.select((ChatCubit cubit) => cubit.state.isAudioFileSaved);

    if (isAudioFileSaved) {
      return ChatRecordedPlayerWidget(
        player: chatCubit.audioPlayer,
        url: chatCubit.state.recordedAudio?.path,
        recordedDuration: chatCubit.recordAudioDuration,
        onDeletePressed: () async {
          if ((await showDeleteAlert(
                  context, S.of(context).doYouWantToDeleteThisAudioMessage)) ==
              true) {
            chatCubit.deleteRecordedAudio();
          }
        },
        onSendPressed: () => chatCubit.sendAnswer(ChatContentType.media),
      );
    } else if (isRecordingAudio) {
      return ChatRecordingWidget(
        onClosePressed: () => chatCubit.cancelRecordingAudio(),
        onStopRecordPressed: () => chatCubit.stopRecordingAudio(),
        recordingStream: chatCubit.state.recordingStream,
      );
    } else {
      return const ChatTextInputWidget();
    }
  }
}
