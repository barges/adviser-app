import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/chats/attachment.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/services/audio_player_service.dart';

class ChatItemWidgetPlayer extends StatefulWidget {
  final bool isQuestion;
  final Attachment attachment;
  final AudioPlayerService player;

  const ChatItemWidgetPlayer({
    super.key,
    required this.isQuestion,
    required this.attachment,
    required this.player,
  });

  @override
  State<ChatItemWidgetPlayer> createState() => _ChatItemWidgetPlayerState();
}

class _ChatItemWidgetPlayerState extends State<ChatItemWidgetPlayer> {
  late final Duration _duration;
  late final String url;
  Duration _position = Duration.zero;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    url = widget.attachment.url ?? '';

    isPlaying = widget.player.getCurrentState(url) == PlayerState.playing;

    _duration = Duration(seconds: widget.attachment.meta?.duration ?? 0);

    widget.player.stateStream.distinct().listen((event) {
      if (event.url == url) {
        if (mounted) {
          setState(() {
            isPlaying = event.playerState == PlayerState.playing;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isPlaying = false;
            _position = Duration.zero;
          });
        }
      }
    });

    widget.player.positionStream.listen((event) {
      if (event.url == url) {
        if (mounted) {
          setState(() {
            _position = event.duration ?? Duration.zero;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: Row(
        children: [
          _PlayPauseBtn(
            isPlaying: isPlaying,
            color: widget.isQuestion
                ? Theme.of(context).primaryColor
                : Theme.of(context).backgroundColor,
            iconColor: widget.isQuestion
                ? Theme.of(context).backgroundColor
                : Theme.of(context).primaryColor,
            onTapPlayPause: () => widget.player.playPause(Uri.parse(url)),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: _PlayProgress(
              player: widget.player,
              url: url,
              duration: _duration,
              position: _position,
              textColor: widget.isQuestion
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).backgroundColor,
              backgroundColor: Theme.of(context).primaryColorLight,
              color: widget.isQuestion
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).backgroundColor,
            ),
          ),
        ],
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

  const _PlayProgress({
    Key? key,
    required this.player,
    required this.url,
    required this.position,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              position.toString().substring(2, 7),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: textColor,
                    fontSize: 12.0,
                  ),
            ),
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
              value: (position.inMilliseconds > 0 &&
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
