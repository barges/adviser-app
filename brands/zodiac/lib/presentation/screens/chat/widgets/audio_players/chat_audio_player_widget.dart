import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/audio/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/audio_players/chat_audio_player_cubit.dart';

class ChatAudioPlayerWidget extends StatelessWidget {
  final bool isOutgoing;
  final String? url;
  final AudioPlayerService player;
  final int duration;

  const ChatAudioPlayerWidget({
    super.key,
    required this.isOutgoing,
    required this.url,
    required this.player,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return BlocProvider(
      key: url != null ? Key(url!) : null,
      create: (_) => ChatAudioPlayerCubit(
        player,
        url,
      ),
      child: SizedBox(
        height: 48.0,
        child: Row(
          children: [
            Builder(builder: (context) {
              final bool isOnline = context.select((MainCubit cubit) =>
                  cubit.state.internetConnectionIsAvailable);
              final bool isPlaying = context.select(
                  (ChatAudioPlayerCubit cubit) => cubit.state.isPlaying);

              final Uri itemUri = Uri.parse(url ?? '');

              return _PlayPauseBtn(
                isPlaying: isPlaying,
                color: isOutgoing ? theme.backgroundColor : theme.primaryColor,
                iconColor:
                    isOutgoing ? theme.primaryColor : theme.backgroundColor,
                onTapPlayPause: () {
                  if (isOnline) {
                    if (chatCubit.audioRecorder.isRecording) {
                      chatCubit.stopRecordingAudio();
                    }
                    player.playPause(itemUri);
                  } else {
                    if (!itemUri.hasScheme || isPlaying) {
                      player.playPause(itemUri);
                    }
                  }
                },
              );
            }),
            const SizedBox(
              width: 12.0,
            ),
            Builder(builder: (context) {
              final Duration position = context
                  .select((ChatAudioPlayerCubit cubit) => cubit.state.position);

              final bool isNotStopped = context.select(
                  (ChatAudioPlayerCubit cubit) => cubit.state.isNotStopped);

              return Expanded(
                child: _PlayProgress(
                  player: player,
                  url: url ?? '',
                  duration: Duration(seconds: duration),
                  position: position,
                  textColor: isOutgoing
                      ? theme.backgroundColor
                      : theme.primaryColorDark,
                  backgroundColor: theme.primaryColorLight,
                  color:
                      isOutgoing ? theme.backgroundColor : theme.primaryColor,
                  isNotStopped: isNotStopped,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PlayPauseBtn extends StatelessWidget {
  final Color iconColor;
  final Color color;
  final bool isPlaying;
  final VoidCallback? onTapPlayPause;

  const _PlayPauseBtn({
    Key? key,
    required this.iconColor,
    required this.color,
    this.isPlaying = false,
    this.onTapPlayPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapPlayPause,
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
  final AudioPlayerService player;
  final String url;
  final Duration position;
  final Duration duration;
  final Color textColor;
  final Color color;
  final Color backgroundColor;
  final bool isNotStopped;

  const _PlayProgress({
    Key? key,
    required this.player,
    required this.url,
    required this.position,
    required this.duration,
    required this.textColor,
    required this.color,
    required this.backgroundColor,
    this.isNotStopped = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: isNotStopped
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            if (isNotStopped)
              Text(
                position.toString().substring(2, 7),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: textColor,
                  fontSize: 12.0,
                ),
              ),
            Text(
              duration.toString().substring(2, 7),
              style: theme.textTheme.bodySmall?.copyWith(
                color: textColor,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4.0,
        ),
        SizedBox(
          height: 8.0,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              activeTickMarkColor: Colors.red,
              inactiveTrackColor: backgroundColor,
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
              trackShape: const RectangularSliderTrackShape(),
            ),
            child: Slider(
              onChanged: (v) {
                final slidePosition = v * duration.inMilliseconds;
                player.seek(url, Duration(milliseconds: slidePosition.round()));
              },
              value: (isNotStopped &&
                      position.inMilliseconds > 0 &&
                      position.inMilliseconds < duration.inMilliseconds)
                  ? position.inMilliseconds / duration.inMilliseconds
                  : 0.0,
            ),
          ),
        ),
      ],
    );
  }
}
