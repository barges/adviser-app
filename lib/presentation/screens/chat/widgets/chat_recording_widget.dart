import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class ChatRecordingWidget extends StatelessWidget {
  final VoidCallback? onClosePressed;
  final VoidCallback? onStopRecordPressed;

  const ChatRecordingWidget({
    Key? key,
    this.onClosePressed,
    this.onStopRecordPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 25,
        right: 25,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClosePressed,
            child: const Icon(
              Icons.clear,
              size: 25,
            ),
          ),
          const Spacer(),
          const Text(
            "from 15 sec to 3 min",
            style: TextStyle(
              color: AppColors.online,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FB),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Assets.vectors.recording.svg(
                  height: 12,
                ),
                const SizedBox(width: 3),
                Container(
                  height: 22,
                  width: 42,
                  alignment: Alignment.center,
                  child: const Text(
                    "0:00",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onStopRecordPressed,
            child: Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: const Color(0xFF3975E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Assets.vectors.stop.svg(
                fit: BoxFit.scaleDown,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
