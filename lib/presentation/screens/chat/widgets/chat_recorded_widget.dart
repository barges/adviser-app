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
    bool isPlayingState = isPlaying;
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
                  StatefulBuilder(builder: (_, StateSetter setState) {
                    return GestureDetector(
                      onTap: () {
                        (isPlayingState
                                ? onPausePlayPressed
                                : onStartPlayPressed)
                            ?.call();
                        setState(() => isPlayingState = !isPlayingState);
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3975E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: isPlayingState
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
                  }),
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
                              final value = isPlayingState && snapshot.hasData
                                  ? snapshot.data!.position.inMilliseconds /
                                      snapshot.data!.duration.inMilliseconds
                                  : 0.0;
                              final time = (isPlayingState && snapshot.hasData)
                                  ? snapshot.data!.position
                                      .toString()
                                      .substring(2, 7)
                                  : "0:00";
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
