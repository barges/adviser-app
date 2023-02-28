import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/message_content_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_image_widget.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/attached_pictures.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_dark.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors_light.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

const _maxTextNumLines = 5;

class ChatTextInputWidget extends StatelessWidget {
  const ChatTextInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<File> attachedPictures =
        context.select((ChatCubit cubit) => cubit.state.attachedPictures);
    final theme = Theme.of(context);
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final bool isAudioQuestion =
        context.select((ChatCubit cubit) => cubit.state.isAudioAnswerEnabled);
    final bool textInputFocused =
        context.select((ChatCubit cubit) => cubit.state.textInputFocused);
    final bool isCollapsed =
        context.select((ChatCubit cubit) => cubit.state.isTextInputCollapsed);
    final double textInputHeight =
        context.select((ChatCubit cubit) => cubit.state.textInputHeight);

    final double bottomTextAreaHeight =
        context.select((ChatCubit cubit) => cubit.state.bottomTextAreaHeight);
    return Stack(
      children: [
        if (!isCollapsed)
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Utils.isDarkMode(context)
                ? AppColorsDark.overlay
                : AppColorsLight.overlay,
          ),
        Positioned(
          bottom: !isCollapsed ? 0.0 : null,
          right: !isCollapsed ? 0.0 : null,
          left: !isCollapsed ? 0.0 : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 10.0),
                  color: theme.canvasColor,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    if (textInputFocused)
                      Builder(builder: (context) {
                        context.select(
                            (ChatCubit cubit) => cubit.state.keyboardOpened);
                        return SolidBottomSheet(
                          controller: chatCubit.textInputSolidController,
                          draggableBody: true,
                          minHeight: textInputHeight,
                          maxHeight: MediaQuery.of(context).size.height -
                              MediaQueryData.fromWindow(window)
                                  .viewPadding
                                  .top -
                              MediaQueryData.fromWindow(window)
                                  .viewInsets
                                  .bottom -
                              MediaQueryData.fromWindow(window)
                                  .viewPadding
                                  .bottom -
                              bottomTextAreaHeight -
                              (AppConstants.appBarHeight / 2) -
                              21.0,
                          headerBar: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 4.0,
                                width: 48.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90.0),
                                  color: theme.hintColor,
                                ),
                              ),
                              const SizedBox(height: 8.0)
                            ],
                          ),
                          body: Builder(builder: (context) {
                            if (isCollapsed) {
                              return _InputTextField(
                                  key: chatCubit.textInputKey);
                            } else {
                              return Expanded(
                                child: _InputTextField(
                                    key: chatCubit.textInputKey),
                              );
                            }
                          }),
                          onShow: () {
                            chatCubit.updateIsTextInputCollapsed(false);
                          },
                          onHide: () {
                            chatCubit.updateIsTextInputCollapsed(true);
                          },
                        );
                      }),
                    Column(
                      key: chatCubit.bottomTextAreaKey,
                      children: [
                        Builder(builder: (context) {
                          final bool isFocused = context.select(
                              (ChatCubit cubit) =>
                                  cubit.state.textInputFocused);
                          return isFocused
                              ? Padding(
                                  padding: EdgeInsets.only(
                                    top: textInputFocused ? 10.0 : 0.0,
                                    bottom: 7.0,
                                  ),
                                  child: const AttachedPictures(),
                                )
                              : const SizedBox.shrink();
                        }),
                        Builder(builder: (context) {
                          final int inputTextLength = context.select(
                              (ChatCubit cubit) => cubit.state.inputTextLength);
                          final bool canAttachPicture =
                              chatCubit.canAttachPictureTo();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
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
                                  if (attachedPictures.isNotEmpty &&
                                      isAudioQuestion)
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
                                            if (chatCubit
                                                .textInputEditingController
                                                .text
                                                .isEmpty) {
                                              chatCubit
                                                  .startRecordingAudio(context);
                                            }
                                          },
                                          child: Opacity(
                                            opacity: chatCubit
                                                    .textInputEditingController
                                                    .text
                                                    .isEmpty
                                                ? 1.0
                                                : 0.4,
                                            child: Assets.vectors.microphone
                                                .svg(
                                                    width:
                                                        AppConstants.iconSize),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              if (!textInputFocused)
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          chatCubit.setTextInputFocus(true);
                                        },
                                        child: inputTextLength > 0
                                            ? Text(
                                                chatCubit
                                                    .textInputEditingController
                                                    .text,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: theme.hoverColor,
                                                  fontSize: 15.0,
                                                  height: 1.2,
                                                ))
                                            : Text(
                                                S.of(context).typeMessage,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: theme.shadowColor,
                                                  fontSize: 15.0,
                                                ),
                                              )),
                                  ),
                                ),
                              Builder(builder: (context) {
                                final isSendButtonEnabled = context.select(
                                    (ChatCubit cubit) =>
                                        cubit.state.isSendButtonEnabled);
                                final bool isFocused = context.select(
                                    (ChatCubit cubit) =>
                                        cubit.state.textInputFocused);

                                if (attachedPictures.isNotEmpty && !isFocused) {
                                  return GestureDetector(
                                    onTap: () {
                                      chatCubit.setTextInputFocus(true);
                                    },
                                    child: AppImageWidget(
                                      uri: Uri.parse(attachedPictures[0].path),
                                      height: 32.0,
                                      width: 32.0,
                                      radius: 12.0,
                                    ),
                                  );
                                } else if (inputTextLength == 0 &&
                                    attachedPictures.isEmpty &&
                                    isAudioQuestion &&
                                    !isFocused) {
                                  return AppIconGradientButton(
                                    onTap: () =>
                                        chatCubit.startRecordingAudio(context),
                                    icon: Assets.vectors.microphone.path,
                                    iconColor: theme.backgroundColor,
                                  );
                                } else if (inputTextLength > 0 ||
                                    attachedPictures.isNotEmpty ||
                                    !isAudioQuestion ||
                                    isFocused) {
                                  return Opacity(
                                    opacity: isSendButtonEnabled ? 1.0 : 0.4,
                                    child: AppIconGradientButton(
                                      onTap: () {
                                        if (isSendButtonEnabled) {
                                          FocusScope.of(context).unfocus();
                                          chatCubit.sendAnswer(
                                              ChatContentType.textMedia);
                                        }
                                      },
                                      icon: Assets.vectors.send.path,
                                      iconColor: theme.backgroundColor,
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }),
                            ],
                          );
                        })
                      ],
                    ),
                  ])),
              const Positioned(
                top: -21.0,
                right: 0.0,
                child: _TextCounter(),
              ),
            ],
          ),
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
    final bool isCollapsed =
        context.select((ChatCubit cubit) => cubit.state.isTextInputCollapsed);

    return LayoutBuilder(
      builder: (context, constraints) {
        context.select((ChatCubit cubit) => cubit.state.inputTextLength);
        final int textNumLines = Utils.getTextNumLines(
          chatCubit.textInputEditingController.text,
          constraints.maxWidth,
          style,
        );
        final double textHeight = Utils.getTextHeight(
          chatCubit.textInputEditingController.text,
          constraints.maxWidth,
          style,
        );

        if (isCollapsed && textNumLines != chatCubit.oldTextInputLines) {
          if (chatCubit.oldTextInputLines < 5) {
            chatCubit.updateHiddenInputHeight(
                textNumLines != 0 ? textHeight * textNumLines : textHeight);
          }
          chatCubit.oldTextInputLines = textNumLines;
        }
        return Scrollbar(
          thickness: 4.0,
          controller: chatCubit.textInputScrollController,
          thumbVisibility: true,
          interactive: true,
          child: TextField(
            scrollController: chatCubit.textInputScrollController,
            controller: chatCubit.textInputEditingController,
            focusNode: chatCubit.textInputFocusNode,
            maxLines: isCollapsed && textNumLines > _maxTextNumLines
                ? _maxTextNumLines
                : null,
            style: style,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  right: isCollapsed && textNumLines > _maxTextNumLines
                      ? 4.0
                      : 0.0),
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
