import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
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
    final File? recordedAudio =
        context.select((ChatCubit cubit) => cubit.state.recordedAudio);

    if (recordedAudio != null) {
      return ChatRecordedPlayerWidget(
        player: chatCubit.audioPlayer,
        url: chatCubit.state.recordedAudio?.path,
        recordedDuration: chatCubit.recordAudioDuration,
        onDeletePressed: () async => await chatCubit.deleteRecordedAudio(),
        onSendPressed: () =>
            chatCubit.sendAnswer(ChatContentType.media, context),
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
