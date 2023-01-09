import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
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
    final theme = Theme.of(context);
    final s = S.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          height: 1.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          color: theme.canvasColor,
          child: Row(
            children: [
              GestureDetector(
                onTap: onClosePressed,
                child: Assets.vectors.close.svg(
                  color: theme.shadowColor,
                ),
              ),
              const Spacer(),
              StreamBuilder<RecordingDisposition>(
                  stream: recordingStream,
                  builder: (_, snapshot) {
                    return Text(
                      s.from15secTo3min,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: snapshot.hasData &&
                                chatCubit.checkMinRecordDurationIsOk()
                            ? AppColors.online
                            : theme.errorColor,
                        fontSize: 12.0,
                      ),
                    );
                  }),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 11.5,
                      width: 11.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.errorColor,
                        border: Border.all(
                          width: 1.5,
                          color: theme.canvasColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    StreamBuilder<RecordingDisposition>(
                        stream: recordingStream,
                        builder: (_, snapshot) {
                          final time =
                              (snapshot.hasData && snapshot.data != null)
                                  ? snapshot.data!.duration
                                      .toString()
                                      .substring(3, 7)
                                  : "0:00";
                          return SizedBox(
                            width: 36.0,
                            child: Text(
                              time,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.hoverColor,
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
                    color: theme.primaryColor,
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                  ),
                  child: Assets.vectors.stop.svg(
                    fit: BoxFit.none,
                    color: theme.backgroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
