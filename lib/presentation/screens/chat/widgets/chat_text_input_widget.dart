import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/ok_cancel_alert.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/attached_pictures.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

const _maxTextNumLines = 6;

class ChatTextInputWidget extends StatelessWidget {
  const ChatTextInputWidget({
    Key? key,
  }) : super(key: key);

  Future<void> _sendAnswer(BuildContext context, ChatCubit chatCubit) async {
    final s = S.of(context);
    final dynamic isConfirmed = await showOkCancelAlert(
      context: context,
      title: s.pleaseConfirmThatYourAnswerIsReadyToBeSent,
      okText: s.confirm,
      actionOnOK: () => Navigator.pop(context, true),
      allowBarrierClick: false,
      isCancelEnabled: true,
    );

    if (isConfirmed == true) {
      chatCubit.sendTextMediaAnswer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final List<File> attachedPictures =
        context.select((ChatCubit cubit) => cubit.state.attachedPictures);
    final isAttachedPictures = chatCubit.isAttachedPictures;
    final isAudio = chatCubit.state.questionFromDB?.isAudio ?? false;

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
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              color: Theme.of(context).canvasColor,
              child: Column(
                children: [
                  if (isAttachedPictures) const _InputTextField(),
                  if (isAttachedPictures)
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
                    return Row(
                      crossAxisAlignment:
                          isAttachedPictures || inputTextLength == 0
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (attachedPictures.length <
                                AppConstants.maxAttachedPictures) {
                              showPickImageAlert(
                                context: context,
                                setImage: chatCubit.attachPicture,
                              );
                            }
                          },
                          child: Opacity(
                            opacity: attachedPictures.length <
                                    AppConstants.maxAttachedPictures
                                ? 1.0
                                : 0.4,
                            child: Assets.vectors.gallery.svg(
                              width: AppConstants.iconSize,
                              color: Theme.of(context).shadowColor,
                            ),
                          ),
                        ),
                        if (isAttachedPictures) const Spacer(),
                        if (!isAttachedPictures)
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: _InputTextField(),
                            ),
                          ),
                        Builder(builder: (context) {
                          final isSendButtonEnabled = context.select(
                                  (ChatCubit cubit) =>
                                      cubit.state.isSendButtonEnabled) ||
                              isAttachedPictures;
                          final isMicrophoneButtonEnabled = context.select(
                              (ChatCubit cubit) =>
                                  cubit.state.isMicrophoneButtonEnabled);

                          return Row(
                            children: [
                              if (inputTextLength == 0 &&
                                  !isAttachedPictures &&
                                  isAudio)
                                Opacity(
                                  opacity:
                                      isMicrophoneButtonEnabled ? 1.0 : 0.4,
                                  child: AppIconGradientButton(
                                    onTap: isMicrophoneButtonEnabled
                                        ? chatCubit.startRecordingAudio
                                        : null,
                                    icon: Assets.vectors.microphone.path,
                                    iconColor:
                                        Theme.of(context).backgroundColor,
                                  ),
                                ),
                              if (inputTextLength > 0 ||
                                  isAttachedPictures ||
                                  !isAudio)
                                Opacity(
                                  opacity: isSendButtonEnabled ? 1.0 : 0.4,
                                  child: AppIconGradientButton(
                                    onTap: () {
                                      if (isSendButtonEnabled) {
                                        _sendAnswer(context, chatCubit);
                                      }
                                    },
                                    icon: Assets.vectors.send.path,
                                    iconColor:
                                        Theme.of(context).backgroundColor,
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
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final TextStyle? style = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).hoverColor,
          fontSize: 15.0,
          height: 0.97,
        );
    return LayoutBuilder(
      builder: (context, constraints) {
        context.select((ChatCubit cubit) => cubit.state.inputTextLength);
        final textNumLines = Utils.getTextNumLines(
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
              hintText: S.of(context).typemessage,
              hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).shadowColor,
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
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final theme = Theme.of(context);
    return Builder(builder: (context) {
      final int inputTextLength =
          context.select((ChatCubit cubit) => cubit.state.inputTextLength);
      final isEnabled =
          context.select((ChatCubit cubit) => cubit.state.isSendButtonEnabled);
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
            padding: const EdgeInsets.all(4.0),
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
      );
    });
  }
}
