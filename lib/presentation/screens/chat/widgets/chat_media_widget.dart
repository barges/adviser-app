import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:shared_advisor_interface/data/models/media_message.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class ChatMediaWidget extends StatelessWidget {
  final MediaMessage mediaMessage;
  final VoidCallback? onStartPlayPressed;
  final VoidCallback? onPausePlayPressed;
  final Stream<PlaybackDisposition>? playbackStream;
  final bool isFinished;
  const ChatMediaWidget({
    Key? key,
    required this.mediaMessage,
    this.onStartPlayPressed,
    this.onPausePlayPressed,
    this.playbackStream,
    this.isFinished = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaybackState = !isFinished;
    return Padding(
      padding: const EdgeInsets.only(
        left: 40,
        right: 8,
        top: 4,
        bottom: 4,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF3975E9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: StatefulBuilder(builder: (_, StateSetter setState) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  (isPlaybackState ? onPausePlayPressed : onStartPlayPressed)
                      ?.call();
                  setState(() => isPlaybackState = !isPlaybackState);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isPlaybackState
                      ? Assets.vectors.pause.svg(
                          fit: BoxFit.scaleDown,
                          color: const Color(0xFF3975E9),
                        )
                      : Assets.vectors.play.svg(
                          fit: BoxFit.scaleDown,
                          color: const Color(0xFF3975E9),
                        ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: StreamBuilder<PlaybackDisposition>(
                        stream: isPlaybackState && !isFinished
                            ? playbackStream
                            : null,
                        builder: (_, snapshot) {
                          final value = snapshot.hasData && !isFinished
                              ? snapshot.data!.position.inMilliseconds /
                                  snapshot.data!.duration.inMilliseconds
                              : 0.0;
                          final time = snapshot.hasData && !isFinished
                              ? snapshot.data!.position
                                  .toString()
                                  .substring(2, 7)
                              : "0:00";
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 48,
                                    child: Text(
                                      time,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 48,
                                    child: Text(
                                      time,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              LinearProgressIndicator(
                                value: (!value.isNaN && !value.isInfinite)
                                    ? value
                                    : 0.0,
                                backgroundColor: const Color(0xFFB7DCFF),
                                color: Colors.white,
                                minHeight: 2,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  const Text(
                                    'Card riading',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFB7DCFF),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Assets.vectors.card.svg(
                                    height: 20,
                                    fit: BoxFit.fitHeight,
                                    color: const Color(0xFFB7DCFF),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    mediaMessage.duration
                                        .toString()
                                        .substring(2, 7),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFB7DCFF),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
