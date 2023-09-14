import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/audio_players/chat_recorded_player_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/audio_recorder/chat_recording_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/chat_text_input_widget.dart';

class ActiveChatInputFieldWidget extends StatelessWidget {
  const ActiveChatInputFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return Builder(builder: (context) {
      final bool isRecording =
          context.select((ChatCubit cubit) => cubit.state.isRecording);
      final File? recordedAudio =
          context.select((ChatCubit cubit) => cubit.state.recordedAudio);

      if (recordedAudio != null) {
        return ChatRecordedPlayerWidget(
          player: chatCubit.audioPlayer,
          url: chatCubit.state.recordedAudio?.path,
          recordedDuration: chatCubit.recordAudioDuration,
          onDeletePressed: () async => await chatCubit.deleteRecordedAudio(),
          onSendPressed: () => chatCubit.sendAudio(),
        );
      } else if (isRecording) {
        return ChatRecordingWidget(
          onClosePressed: () => chatCubit.cancelRecordingAudio(),
          onStopRecordPressed: () => chatCubit.stopRecordingAudio(),
        );
      } else {
        return Builder(
          builder: (context) {
            final ChatMessageModel? repliedMessage =
                context.select((ChatCubit cubit) => cubit.state.repliedMessage);
            return ChatTextInputWidget(
              repliedMessage: repliedMessage,
            );
          },
        );
      }
    });
  }
}