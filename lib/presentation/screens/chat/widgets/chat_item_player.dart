import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_item_type_getter_mixin.dart';

class ChatItemPlayer extends StatelessWidget with ChatItemTypeGetter {
  final bool isQuestion;
  final Attachment attachment;
  const ChatItemPlayer({
    super.key,
    required this.isQuestion,
    required this.attachment,
  });
  @override
  bool get isAnswer => !isQuestion;

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final isPlayingAudio =
        context.select((ChatCubit cubit) => cubit.state.isPlayingAudio);
    final isPlayingAudioFinished =
        context.select((ChatCubit cubit) => cubit.state.isPlayingAudioFinished);
    final isCurrent = attachment.url == chatCubit.state.audioUrl;
    return _ChatItemPlayer(
      onStartPlayPressed: () {
        chatCubit.startPlayAudio(attachment.url ?? '');
      },
      onPausePlayPressed: () => chatCubit.pauseAudio(),
      isPlaying: isCurrent && isPlayingAudio,
      isPlayingFinished: isCurrent ? isPlayingAudioFinished : true,
      playbackStream: chatCubit.onMediaProgress,
      duration: attachment.duration,
      textColor: getterType(
        question: Theme.of(context).primaryColor,
        answer: Theme.of(context).backgroundColor,
      ),
      colorProgressIndicator: getterType(
        question: Theme.of(context).primaryColor,
        answer: Theme.of(context).backgroundColor,
      ),
      bgColorProgressIndicator: getterType(
        question: Theme.of(context).primaryColorLight,
        answer: Theme.of(context).primaryColorLight,
      ),
      iconColor: getterType(
        question: Theme.of(context).backgroundColor,
        answer: Theme.of(context).primaryColor,
      ),
      colorBtn: getterType(
        question: Theme.of(context).primaryColor,
        answer: Theme.of(context).backgroundColor,
      ),
    );
  }
}

class _ChatItemPlayer extends StatelessWidget {
  final Duration duration;
  final Color iconColor;
  final Color colorBtn;
  final Color textColor;
  final Color colorProgressIndicator;
  final Color bgColorProgressIndicator;
  final bool isPlaying;
  final bool isPlayingFinished;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final Stream<PlaybackDisposition>? playbackStream;
  double prevValue = 0.0;
  _ChatItemPlayer({
    Key? key,
    required this.duration,
    required this.iconColor,
    required this.colorBtn,
    required this.textColor,
    required this.colorProgressIndicator,
    required this.bgColorProgressIndicator,
    this.isPlaying = false,
    this.isPlayingFinished = false,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.playbackStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PlayPauseBtn(
          isPlaying: isPlaying,
          color: colorBtn,
          iconColor: iconColor,
          onStartPlayPressed: onStartPlayPressed,
          onPausePlayPressed: onPausePlayPressed,
        ),
        const SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: StreamBuilder<PlaybackDisposition>(
            stream: isPlaying && !isPlayingFinished ? playbackStream : null,
            builder: (_, snapshot) {
              double value = !isPlayingFinished && snapshot.hasData
                  ? snapshot.data!.position.inMilliseconds /
                      snapshot.data!.duration.inMilliseconds
                  : 0.0;
              if (snapshot.connectionState == ConnectionState.waiting) {
                value = prevValue;
              }
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                prevValue = snapshot.data!.position.inMilliseconds /
                    snapshot.data!.duration.inMilliseconds;
              }
              final String time = !isPlayingFinished && snapshot.hasData
                  ? snapshot.data!.position.toString().substring(2, 7)
                  : "00:00";
              return _PlayProgress(
                value: value,
                time: !isPlayingFinished ? time : null,
                duration: duration,
                textColor: textColor,
                backgroundColor: bgColorProgressIndicator,
                color: colorProgressIndicator,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlayPauseBtn extends StatelessWidget {
  final Color iconColor;
  final Color color;
  final bool isPlaying;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  const _PlayPauseBtn({
    Key? key,
    required this.iconColor,
    required this.color,
    this.isPlaying = false,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        (isPlaying ? onPausePlayPressed : onStartPlayPressed)?.call();
      },
      child: Container(
        width: 34.0,
        height: 34.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: isPlaying
            ? Assets.vectors.pause.svg(
                fit: BoxFit.none,
                color: iconColor,
              )
            : Assets.vectors.play.svg(
                fit: BoxFit.none,
                color: iconColor,
              ),
      ),
    );
  }
}

class _PlayProgress extends StatelessWidget {
  final double value;
  final String? time;
  final Duration duration;
  final Color textColor;
  final Color color;
  final Color backgroundColor;
  const _PlayProgress({
    Key? key,
    required this.value,
    required this.time,
    required this.duration,
    required this.textColor,
    required this.color,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (time != null)
              Text(
                time!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontSize: 12.0,
                    ),
              ),
            const Spacer(),
            Text(
              duration.toString().substring(2, 7),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontSize: 12.0,
                  ),
            ),
          ],
        ),
        const SizedBox(
          height: 8.0,
        ),
        LinearProgressIndicator(
          value: (value.isNaN || value.isInfinite) ? 0.0 : value,
          backgroundColor: backgroundColor,
          color: color,
          minHeight: 2.0,
        ),
        const SizedBox(
          height: 24.0,
        )
      ],
    );
  }
}
