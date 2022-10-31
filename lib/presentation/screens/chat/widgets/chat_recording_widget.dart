import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class ChatRecordingWidget extends StatelessWidget {
  final VoidCallback? onClosePressed;
  final VoidCallback? onStopRecordPressed;
  final Stream<RecordingDisposition>? recordingStream;

  const ChatRecordingWidget({
    Key? key,
    this.onClosePressed,
    this.onStopRecordPressed,
    this.recordingStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 25.0,
        right: 25.0,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClosePressed,
            child: const Icon(
              Icons.clear,
              size: 25.0,
            ),
          ),
          const Spacer(),
          const Text(
            "from 15 sec to 3 min",
            style: TextStyle(
              color: AppColors.online,
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6.0,
              vertical: 2.0,
            ),
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Assets.vectors.recording.svg(
                  height: 12.0,
                ),
                const SizedBox(width: 3.0),
                Container(
                  width: 40.0,
                  height: 22.0,
                  alignment: Alignment.center,
                  child: StreamBuilder<RecordingDisposition>(
                      stream: recordingStream,
                      builder: (_, snapshot) {
                        final time = (snapshot.hasData && snapshot.data != null)
                            ? snapshot.data!.duration.toString().substring(2, 7)
                            : "00:00";
                        return SizedBox(
                          width: 42.0,
                          child: Text(
                            time,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onStopRecordPressed,
            child: Container(
              height: 34.0,
              width: 34.0,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Assets.vectors.stop.svg(
                fit: BoxFit.scaleDown,
                color: Get.theme.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
