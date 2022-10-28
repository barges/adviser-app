import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class ChatRecordedWidget extends StatelessWidget {
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final VoidCallback? onDeletePressed;
  final VoidCallback? onSendPressed;
  final bool isPlaying;
  final Stream<PlaybackDisposition>? playbackStream;

  const ChatRecordedWidget({
    Key? key,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.onDeletePressed,
    this.onSendPressed,
    this.playbackStream,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        left: 25,
        right: 25,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: null, //onPhotoPressed,
            child: Assets.vectors.photo.svg(),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 8,
              right: 13,
            ),
            child: SizedBox(
              height: 37,
              child: VerticalDivider(
                thickness: 1,
                color: Color(0xFFE7ECF4),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  PlayPauseBtn(
                    isPlaying: isPlaying,
                    onStartPlayPressed: onStartPlayPressed,
                    onPausePlayPressed: onPausePlayPressed,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: StreamBuilder<PlaybackDisposition>(
                            stream: playbackStream,
                            builder: (_, snapshot) {
                              final value =
                                  playbackStream != null && snapshot.hasData
                                      ? snapshot.data!.position.inMilliseconds /
                                          snapshot.data!.duration.inMilliseconds
                                      : 0.0;
                              final time =
                                  playbackStream != null && snapshot.hasData
                                      ? snapshot.data!.position
                                          .toString()
                                          .substring(2, 7)
                                      : "00:00";
                              return PlayProgress(
                                value: value,
                                time: time,
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: onDeletePressed,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 2,
                              right: 8,
                            ),
                            child: Assets.vectors.delete.svg(
                              fit: BoxFit.scaleDown,
                              color: const Color(0xFF9396A3),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: onSendPressed,
            child: Assets.images.send.image(
              fit: BoxFit.fitWidth,
              width: 35,
            ),
          )
        ],
      ),
    );
  }
}

class PlayPauseBtn extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  const PlayPauseBtn({
    Key? key,
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
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: const Color(0xFF3975E9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isPlaying
            ? Assets.vectors.pause.svg(
                fit: BoxFit.scaleDown,
                color: Colors.white,
              )
            : Assets.vectors.play.svg(
                fit: BoxFit.scaleDown,
                color: Colors.white,
              ),
      ),
    );
  }
}

class PlayProgress extends StatelessWidget {
  final double value;
  final String time;
  const PlayProgress({
    Key? key,
    required this.value,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: const Color(0xFFB7DCFF),
            color: Colors.blue,
            minHeight: 2,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 51,
          child: Text(
            time,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
