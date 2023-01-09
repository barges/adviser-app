import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/attached_pictures.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

const _maxTextNumLines = 5;

class ChatTextInputWidget extends StatelessWidget {
  const ChatTextInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.select((ChatCubit cubit) => cubit.state.attachedPictures);
    final theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final List<File> attachedPictures = chatCubit.state.attachedPictures;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(
              height: 1.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              color: theme.canvasColor,
              child: Column(
                children: [
                  if (attachedPictures.isNotEmpty) const _InputTextField(),
                  if (attachedPictures.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                        bottom: 7.0,
                      ),
                      child: AttachedPictures(),
                    ),
                  Builder(builder: (context) {
                    final int inputTextLength = context.select(
                        (ChatCubit cubit) => cubit.state.inputTextLength);
                    final bool canAttachPicture =
                        chatCubit.canAttachPictureTo();
                    final bool canRecordAudio = chatCubit.canRecordAudio;
                    return Row(
                      crossAxisAlignment:
                          attachedPictures.isNotEmpty || inputTextLength == 0
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (canAttachPicture) {
                              showPickImageAlert(
                                context: context,
                                setImage: chatCubit.attachPicture,
                              );
                            }
                          },
                          child: Opacity(
                            opacity: canAttachPicture ? 1.0 : 0.4,
                            child: Assets.vectors.gallery.svg(
                              width: AppConstants.iconSize,
                              color: theme.shadowColor,
                            ),
                          ),
                        ),
                        if (attachedPictures.isNotEmpty)
                          Row(
                            children: [
                              const SizedBox(
                                height: 28.0,
                                child: VerticalDivider(
                                  width: 24.0,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (canRecordAudio) {
                                    chatCubit.startRecordingAudio(context);
                                  }
                                },
                                child: Opacity(
                                  opacity: canRecordAudio ? 1.0 : 0.4,
                                  child: Assets.vectors.microphone
                                      .svg(width: AppConstants.iconSize),
                                ),
                              ),
                            ],
                          ),
                        if (attachedPictures.isNotEmpty) const Spacer(),
                        if (attachedPictures.isEmpty)
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: _InputTextField(),
                            ),
                          ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Builder(builder: (context) {
                          final isSendButtonEnabled = context.select(
                              (ChatCubit cubit) =>
                                  cubit.state.isSendButtonEnabled);

                          final bool isAudioQuestion = context.select(
                              (ChatCubit cubit) =>
                                  cubit.state.isAudioAnswerEnabled);

                          return Row(
                            children: [
                              if (inputTextLength == 0 &&
                                  attachedPictures.isEmpty &&
                                  isAudioQuestion)
                                AppIconGradientButton(
                                  onTap: () =>
                                      chatCubit.startRecordingAudio(context),
                                  icon: Assets.vectors.microphone.path,
                                  iconColor: theme.backgroundColor,
                                ),
                              if (inputTextLength > 0 ||
                                  attachedPictures.isNotEmpty ||
                                  !isAudioQuestion)
                                Opacity(
                                  opacity: isSendButtonEnabled ? 1.0 : 0.4,
                                  child: AppIconGradientButton(
                                    onTap: () {
                                      if (isSendButtonEnabled) {
                                        chatCubit.sendAnswer(
                                            ChatContentType.textMedia);
                                      }
                                    },
                                    icon: Assets.vectors.send.path,
                                    iconColor: theme.backgroundColor,
                                  ),
                                ),
                            ],
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        const Positioned(
          top: -21.0,
          right: 0.0,
          child: _TextCounter(),
        ),
      ],
    );
  }
}

class _InputTextField extends StatelessWidget {
  const _InputTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final TextStyle? style = theme.textTheme.bodySmall?.copyWith(
      color: theme.hoverColor,
      fontSize: 15.0,
      height: 1.2,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        context.select((ChatCubit cubit) => cubit.state.inputTextLength);
        final int textNumLines = Utils.getTextNumLines(
          chatCubit.textEditingController.text,
          constraints.maxWidth,
          style,
        );
        return Scrollbar(
          thickness: 4.0,
          controller: chatCubit.textInputScrollController,
          thumbVisibility: true,
          interactive: true,
          child: TextField(
            scrollController: chatCubit.textInputScrollController,
            controller: chatCubit.textEditingController,
            maxLines: textNumLines > _maxTextNumLines ? _maxTextNumLines : null,
            style: style,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  right: textNumLines > _maxTextNumLines ? 4.0 : 0.0),
              isCollapsed: true,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: S.of(context).typeMessage,
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.shadowColor,
                fontSize: 15.0,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TextCounter extends StatelessWidget {
  const _TextCounter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();

    return Builder(builder: (context) {
      final int inputTextLength =
          context.select((ChatCubit cubit) => cubit.state.inputTextLength);
      final isEnabled =
          context.select((ChatCubit cubit) => cubit.state.isSendButtonEnabled);
      context.select((ChatCubit cubit) => cubit.state.questionFromDB);
      return Container(
        width: 94.0,
        height: 22.0,
        padding: const EdgeInsets.only(
          left: 1.0,
          top: 1.0,
        ),
        decoration: BoxDecoration(
          color: theme.hintColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(4.0)),
        ),
        child: Container(
          width: 92.0,
          height: 21.0,
          decoration: BoxDecoration(
            color: theme.canvasColor,
            borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(4.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
            ),
            child: Center(
              child: Text(
                textAlign: TextAlign.center,
                '$inputTextLength/${chatCubit.minTextLength}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isEnabled ? AppColors.online : theme.errorColor,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
