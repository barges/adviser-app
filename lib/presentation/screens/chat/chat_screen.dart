import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/chats/chat_item.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/chat_conversation_app_bar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recorded_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_recording_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_input_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_media_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_text_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_delete_alert.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class ChatScreen extends StatelessWidget {
  final ChatItem _question = Get.arguments;
  ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textCounterWidth = 92.0;
    return BlocProvider(
      create: (_) => ChatCubit(getIt.get<ChatsRepository>(), _question),
      child: Builder(
        builder: (context) {
          final ChatCubit chatCubit = context.read<ChatCubit>();
          final Brand selectedBrand =
              context.select((MainCubit cubit) => cubit.state.currentBrand);
          return Scaffold(
            appBar: ChatConversationAppBar(
              title: _question.clientName ?? '',
              selectedBrand: selectedBrand,
              question: _question,
            ),
            backgroundColor: Theme.of(context).canvasColor,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Builder(
                          builder: (context) {
                            final List<ChatItem> items = context.select(
                                (ChatCubit cubit) => cubit.state.messages);
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: 12),
                                controller: chatCubit.messagesScrollController,
                                reverse: true,
                                itemBuilder: (_, index) => _ChatItemWidget(
                                    items[index],
                                    onPressedTryAgain: !items[index].isSent
                                        ? chatCubit.sendAnswerAgain
                                        : null),
                                itemCount: items.length,
                              ),
                            );
                          },
                        ),
                        const Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: _TextCounter(
                            width: textCounterWidth,
                            height: 22.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Theme.of(context).canvasColor,
                    child: Stack(
                      children: [
                        Builder(
                          builder: (context) {
                            final bool isRecordingAudio = context.select(
                                (ChatCubit cubit) =>
                                    cubit.state.isRecordingAudio);
                            final bool isAudioFileSaved = context.select(
                                (ChatCubit cubit) =>
                                    cubit.state.isAudioFileSaved);
                            final isPlayingRecordedAudio = context.select(
                                (ChatCubit cubit) =>
                                    cubit.state.isPlayingRecordedAudio);

                            if (isAudioFileSaved) {
                              return ChatRecordedWidget(
                                isPlaying: isPlayingRecordedAudio,
                                playbackStream: chatCubit.state.playbackStream,
                                onStartPlayPressed: () =>
                                    chatCubit.startPlayRecordedAudio(),
                                onPausePlayPressed: () =>
                                    chatCubit.pauseRecordedAudio(),
                                onDeletePressed: () async {
                                  final bool? isDelete = await showDeleteAlert(
                                      context,
                                      S.of(context).doYouWantToDeleteImage);
                                  if (isDelete!) {
                                    chatCubit.deletedRecordedAudio();
                                  }
                                },
                                onSendPressed: () => chatCubit.sendMedia(),
                              );
                            }

                            if (isRecordingAudio) {
                              return ChatRecordingWidget(
                                onClosePressed: () =>
                                    chatCubit.cancelRecordingAudio(),
                                onStopRecordPressed: () =>
                                    chatCubit.stopRecordingAudio(),
                                recordingStream:
                                    chatCubit.state.recordingStream,
                              );
                            } else {
                              return const ChatTextInputWidget();
                            }
                          },
                        ),
                        const Divider(
                          height: 1.0,
                          endIndent: textCounterWidth,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChatItemWidget extends StatelessWidget {
  final ChatItem item;
  final VoidCallback? onPressedTryAgain;
  const _ChatItemWidget(
    this.item, {
    Key? key,
    this.onPressedTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.isMedia) {
      if (item.content != null && item.content!.isNotEmpty) {
        return ChatTextMediaWidget(
          item: item,
          onPressedTryAgain: onPressedTryAgain,
        );
      }

      return ChatMediaWidget(
        item: item,
        onPressedTryAgain: onPressedTryAgain,
      );
    }

    return ChatTextWidget(
      item: item,
      onPressedTryAgain: onPressedTryAgain,
    );
  }
}

class _TextCounter extends StatelessWidget {
  final double width;
  final double height;
  const _TextCounter({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final int inputTextLength =
          context.select((ChatCubit cubit) => cubit.state.inputTextLength);
      return Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(4.0)),
              border: Border(
                top: BorderSide(color: Theme.of(context).hintColor),
                right: BorderSide(color: Theme.of(context).hintColor),
                bottom: BorderSide(color: Theme.of(context).hintColor),
                left: BorderSide(color: Theme.of(context).hintColor),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                textAlign: TextAlign.center,
                '${AppConstants.maxTextLength}/$inputTextLength',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.online,
                      fontSize: 12.0,
                    ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Theme.of(context).canvasColor,
              width: width,
              height: 1,
            ),
          ),
        ],
      );
    });
  }
}
