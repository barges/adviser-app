import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app_constants.dart';
import '../../../../../generated/assets/assets.gen.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../themes/app_colors.dart';
import '../../chat_cubit.dart';

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
    final theme = Theme.of(context);
    final s = SFortunica.of(context);
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
              Builder(builder: (context) {
                context
                    .select((ChatCubit cubit) => cubit.state.recordingDuration);

                return Text(
                  s.fromXsecToYminFortunica(chatCubit.minRecordDurationInSec,
                      chatCubit.maxRecordDurationInMinutes),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: chatCubit.checkMinRecordDurationIsOk()
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
                      height: 11.0,
                      width: 11.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.errorColor,
                        border: Border.all(
                          width: 1.5,
                          color: theme.canvasColor,
                        ),
                      ),
                    ),
                    Builder(builder: (context) {
                      Duration duration = context.select(
                          (ChatCubit cubit) => cubit.state.recordingDuration);
                      final time = duration.toString().substring(3, 7);
                      return SizedBox(
                        width: 38.0,
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
                key: const Key('stopRecordingButton'),
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
