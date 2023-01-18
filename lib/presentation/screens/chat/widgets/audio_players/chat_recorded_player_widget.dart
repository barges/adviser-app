import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/attachment_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/attached_pictures.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/audio_players/chat_audio_player_cubit.dart';
import 'package:shared_advisor_interface/presentation/services/audio_player_service.dart';

class ChatRecordedPlayerWidget extends StatelessWidget {
  final AudioPlayerService player;
  final int? recordedDuration;
  final String? url;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onSendPressed;

  const ChatRecordedPlayerWidget({
    Key? key,
    required this.player,
    this.recordedDuration,
    this.url,
    this.onDeletePressed,
    this.onSendPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();

    return BlocProvider(
      create: (_) => ChatAudioPlayerCubit(
        player,
        url,
      ),
      child: Builder(builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 1.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              color: Theme.of(context).canvasColor,
              child: Column(
                children: [
                  Builder(builder: (context) {
                    final List<File> attachedPictures = context.select(
                        (ChatCubit cubit) => cubit.state.attachedPictures);
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
                        context.select(
                            (ChatCubit cubit) => cubit.state.attachedPictures);
                        final bool canAttachPicture =
                            chatCubit.canAttachPictureTo(
                                attachmentType: AttachmentType.audio);

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
                              child: Opacity(
                                opacity: canAttachPicture ? 1.0 : 0.4,
                                child: Assets.vectors.gallery.svg(
                                  width: AppConstants.iconSize,
                                  color: Theme.of(context).shadowColor,
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
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 12.0,
                        ),
                        child: Opacity(
                          opacity: 0.4,
                          child: Assets.vectors.microphone
                              .svg(width: AppConstants.iconSize),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(
                                AppConstants.buttonRadius),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Builder(builder: (context) {
                                  final bool isPlaying = context.select(
                                      (ChatAudioPlayerCubit cubit) =>
                                          cubit.state.isPlaying);

                                  final Duration position = context.select(
                                      (ChatAudioPlayerCubit cubit) =>
                                          cubit.state.position);

                                  return Row(
                                    children: [
                                      _PlayPauseBtn(
                                        isPlaying: isPlaying,
                                        onTapPlayPause: () => player
                                            .playPause(Uri.parse(url ?? '')),
                                      ),
                                      const SizedBox(
                                        width: 8.0,
                                      ),
                                      Expanded(
                                        child: _PlayProgress(
                                          player: player,
                                          url: url ?? '',
                                          position: position,
                                          duration: Duration(
                                              seconds: recordedDuration ?? 0),
                                          isPlaying: isPlaying,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              GestureDetector(
                                onTap: onDeletePressed,
                                child: Padding(
                                  padding: const EdgeInsets.only(
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
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Builder(builder: (context) {
                        final bool isSendButtonEnabled = context.select(
                            (ChatCubit cubit) =>
                                cubit.state.isSendButtonEnabled);
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
      }),
    );
  }
}

class _PlayPauseBtn extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onTapPlayPause;

  const _PlayPauseBtn({
    Key? key,
    this.isPlaying = false,
    this.onTapPlayPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapPlayPause,
      child: Container(
        width: AppConstants.iconButtonSize,
        height: AppConstants.iconButtonSize,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: isPlaying
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
  final AudioPlayerService player;
  final String url;
  final Duration position;
  final Duration duration;
  final bool isPlaying;

  const _PlayProgress({
    Key? key,
    required this.player,
    required this.url,
    required this.position,
    required this.duration,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 8.0,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Theme.of(context).primaryColor,
                inactiveTrackColor: Theme.of(context).canvasColor,
                trackHeight: 2.0,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                trackShape: const RectangularSliderTrackShape(),
              ),
              child: Slider(
                onChanged: (v) {
                  final slidePosition = v * duration.inMilliseconds;
                  player.seek(
                      url, Duration(milliseconds: slidePosition.round()));
                },
                value: (position.inMilliseconds > 0 &&
                        position.inMilliseconds < duration.inMilliseconds)
                    ? position.inMilliseconds / duration.inMilliseconds
                    : 0.0,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        SizedBox(
          width: 38.0,
          child: Text(
            isPlaying
                ? position.toString().substring(3, 7)
                : duration.toString().substring(3, 7),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hoverColor,
                ),
          ),
        ),
      ],
    );
  }
}
