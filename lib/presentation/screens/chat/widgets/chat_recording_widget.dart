import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
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
      padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClosePressed,
            child: Assets.vectors.close.svg(
              color: Theme.of(context).shadowColor,
            ),
          ),
          const Spacer(),
          Text(
            S.of(context).from15secTo3min,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.online,
                  fontSize: 12.0,
                ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
            child: Row(
              children: [
                Container(
                  height: 8.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).errorColor,
                    border: Border.all(
                      width: 1.5,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4.0),
                StreamBuilder<RecordingDisposition>(
                    stream: recordingStream,
                    builder: (_, snapshot) {
                      final time = (snapshot.hasData && snapshot.data != null)
                          ? snapshot.data!.duration.toString().substring(2, 7)
                          : "00:00";
                      return SizedBox(
                        width: 48.0,
                        child: Text(
                          time,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).hoverColor,
                                    fontSize: 15.0,
                                  ),
                        ),
                      );
                    }),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onStopRecordPressed,
            child: Container(
              height: AppConstants.iconButtonSize,
              width: AppConstants.iconButtonSize,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              ),
              child: Assets.vectors.stop.svg(
                fit: BoxFit.none,
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
