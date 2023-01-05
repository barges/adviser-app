import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/attached_pictures.dart';

class ChatRecordedWidget extends StatelessWidget {
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onSendPressed;

  const ChatRecordedWidget({
    Key? key,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.onDeletePressed,
    this.onSendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          height: 1.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          color: Theme.of(context).canvasColor,
          child: Column(
            children: [
              Builder(builder: (context) {
                final List<File> attachedPictures = context
                    .select((ChatCubit cubit) => cubit.state.attachedPictures);
                return attachedPictures.isNotEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(
                          top: 4.0,
                          bottom: 12.0,
                        ),
                        child: AttachedPictures(),
                      )
                    : const SizedBox.shrink();
              }),
              Row(
                children: [
                  Builder(builder: (context) {
                    final List<File> attachedPictures = context.select(
                        (ChatCubit cubit) => cubit.state.attachedPictures);
                    final bool canAttachPicture = chatCubit.canAttachPictureTo(
                        attachmentType: AttachmentType.audio);
                    final bool canRecordAudio = chatCubit.canRecordAudio;
                    final File? recordedAudio = context.select(
                      (ChatCubit cubit) => cubit.state.recordedAudio,
                    );
                    final bool audioRecordingButtonIsEnabled =
                        canRecordAudio && recordedAudio == null;

                    return Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (canAttachPicture) {
                              showPickImageAlert(
                                context: context,
                                setImage: chatCubit.attachPicture,
                              );
                            }
                          },
                          child: Column(
                            children: [
                              Opacity(
                                opacity: canAttachPicture ? 1.0 : 0.4,
                                child: Assets.vectors.gallery.svg(
                                  width: AppConstants.iconSize,
                                  color: Theme.of(context).shadowColor,
                                ),
                              ),
                              // temporary for testing
                              if (recordedAudio != null)
                                Text(
                                    '${recordedAudio.sizeInMb.toString().substring(0, 5)} Mb',
                                    style: const TextStyle(fontSize: 12.0)),
                            ],
                          ),
                        ),
                        if (attachedPictures.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              if (audioRecordingButtonIsEnabled) {
                                chatCubit.startRecordingAudio(context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                              ),
                              child: Opacity(
                                opacity:
                                    audioRecordingButtonIsEnabled ? 1.0 : 0.4,
                                child: Assets.vectors.microphone
                                    .svg(width: AppConstants.iconSize),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                  const SizedBox(
                    height: 28.0,
                    child: VerticalDivider(
                      width: 24.0,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(AppConstants.buttonRadius),
                      ),
                      child: Row(
                        children: [
                          _PlayPauseBtn(
                            onStartPlayPressed: onStartPlayPressed,
                            onPausePlayPressed: onPausePlayPressed,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Builder(builder: (context) {
                                    final playbackStream = context.select(
                                        (ChatCubit cubit) =>
                                            cubit.state.playbackStream);
                                    return StreamBuilder<PlaybackDisposition>(
                                      stream: playbackStream,
                                      builder: (_, snapshot) {
                                        final value = playbackStream != null &&
                                                snapshot.hasData
                                            ? snapshot.data!.position
                                                    .inMilliseconds /
                                                snapshot.data!.duration
                                                    .inMilliseconds
                                            : 0.0;
                                        return _PlayProgress(
                                          value: value,
                                          duration:
                                              chatCubit.recordAudioDuration !=
                                                      null
                                                  ? chatCubit
                                                      .recordAudioDuration!
                                                      .formatMMSS
                                                  : "00:00",
                                        );
                                      },
                                    );
                                  }),
                                ),
                                GestureDetector(
                                  onTap: onDeletePressed,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      right: 4.0,
                                    ),
                                    child: Assets.vectors.delete.svg(
                                        width: AppConstants.iconSize,
                                        color: Theme.of(context).shadowColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Builder(builder: (context) {
                    final bool isSendButtonEnabled = context.select(
                        (ChatCubit cubit) => cubit.state.isSendButtonEnabled);
                    return Opacity(
                      opacity: isSendButtonEnabled ? 1.0 : 0.4,
                      child: AppIconGradientButton(
                        onTap: isSendButtonEnabled ? onSendPressed : null,
                        icon: Assets.vectors.send.path,
                        iconColor: Theme.of(context).backgroundColor,
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayPauseBtn extends StatelessWidget {
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;

  const _PlayPauseBtn({
    Key? key,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlayingRecordedAudio =
        context.select((ChatCubit cubit) => cubit.state.isPlayingRecordedAudio);
    return GestureDetector(
      onTap: () {
        (isPlayingRecordedAudio ? onPausePlayPressed : onStartPlayPressed)
            ?.call();
      },
      child: Container(
        width: AppConstants.iconButtonSize,
        height: AppConstants.iconButtonSize,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: isPlayingRecordedAudio
            ? Assets.vectors.pause.svg(
                fit: BoxFit.none,
                color: Theme.of(context).backgroundColor,
              )
            : Assets.vectors.play.svg(
                fit: BoxFit.none,
                color: Theme.of(context).backgroundColor,
              ),
      ),
    );
  }
}

class _PlayProgress extends StatelessWidget {
  final double value;
  final String duration;

  const _PlayProgress({
    Key? key,
    required this.value,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Theme.of(context).canvasColor,
            color: Theme.of(context).primaryColor,
            minHeight: 2.0,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        SizedBox(
          width: 48.0,
          child: Text(
            duration,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hoverColor,
                ),
          ),
        ),
      ],
    );
  }
}
