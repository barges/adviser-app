import 'dart:io';
import 'dart:ui';

import 'package:fortunica/presentation/screens/chat/chat_state.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:fortunica/data/models/enums/message_content_type.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:fortunica/presentation/screens/chat/chat_cubit.dart';
import 'package:fortunica/presentation/screens/chat/widgets/attached_pictures.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

const grabbingHeight = 16.0;
const textCounterHeight = 21.0;
const scrollbarThickness = 4.0;

class ChatTextInputWidget extends StatelessWidget {
  const ChatTextInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (prev, current) =>
      prev.inputTextLength != current.inputTextLength,
      listener: (context, state) {
        final double maxWidth = MediaQuery.of(context).size.width -
            scrollbarThickness -
            AppConstants.horizontalScreenPadding * 2;
        final TextStyle? style = theme.textTheme.bodySmall?.copyWith(
          color: theme.hoverColor,
          fontSize: 15.0,
          height: 1.2,
        );
        chatCubit.updateHiddenInputHeight(
          Utils.getTextHeight(
              chatCubit.textInputEditingController.text, style, maxWidth),
          Utils.getTextHeight('\n\n\n\n', style, maxWidth),
        );
      },
      child: Builder(
        builder: (context) {

          final double bottomTextAreaHeight =
          context.select((ChatCubit cubit) => cubit.state.bottomTextAreaHeight);

          final List<File> attachedPictures =
          context.select((ChatCubit cubit) => cubit.state.attachedPictures);
          final bool isAudioQuestion =
          context.select((ChatCubit cubit) => cubit.state.isAudioAnswerEnabled);
          final bool textInputFocused =
          context.select((ChatCubit cubit) => cubit.state.textInputFocused);
          final bool isStretchedTextField =
          context.select((ChatCubit cubit) => cubit.state.isStretchedTextField);

          context.select((ChatCubit cubit) => cubit.state.keyboardOpened);

          return Consumer<ScreenHeight>(builder: (context, _res, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (textInputFocused)
                  Builder(builder: (context) {
                    final double textInputHeight = context
                        .select((ChatCubit cubit) => cubit.state.textInputHeight);

                    final double h = size.height -
                        MediaQueryData.fromWindow(window).viewPadding.top -
                        MediaQueryData.fromWindow(window).viewInsets.bottom -
                        bottomTextAreaHeight -
                        (AppConstants.appBarHeight / 2) -
                        textCounterHeight;

                    return Flexible(
                      child: SnappingSheet(
                        grabbingHeight: grabbingHeight,
                        onSheetMoved: (data) {
                          if (data.relativeToSnappingPositions > 0.1) {
                            chatCubit.updateTextFieldIsCollapse(false);
                          } else if (data.relativeToSheetHeight < 0.0) {
                            chatCubit.textInputFocusNode.unfocus();
                          }
                        },
                        onSnapCompleted: (data, position) {
                          if (data.relativeToSnappingPositions == 0.0 &&
                              !chatCubit.state.isTextInputCollapsed) {
                            chatCubit.updateTextFieldIsCollapse(true);
                            chatCubit.setStretchedTextField(false);
                          } else if (data.relativeToSnappingPositions == 1.0) {
                            chatCubit.setStretchedTextField(true);
                          }
                        },
                        controller: chatCubit.controller,
                        initialSnappingPosition: SnappingPosition.pixels(
                          positionPixels: textInputHeight + grabbingHeight * 2,
                        ),
                        snappingPositions: [
                          SnappingPosition.pixels(
                            positionPixels: textInputHeight + grabbingHeight * 2,
                          ),
                          SnappingPosition.pixels(
                            positionPixels: h + grabbingHeight,
                          ),
                        ],
                        grabbing: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: grabbingHeight,
                              decoration:
                                  BoxDecoration(color: theme.canvasColor, boxShadow: [
                                BoxShadow(
                                  blurRadius: 2.0,
                                  spreadRadius: 2.0,
                                  color: theme.canvasColor,
                                  offset: const Offset(0, 10),
                                )
                              ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 1.0,
                                    color: theme.hintColor,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5.0),
                                    height: 4.0,
                                    width: 48.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90.0),
                                      color: theme.hintColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0)
                                ],
                              ),
                            ),
                            const Positioned(
                              top: -textCounterHeight,
                              right: 0.0,
                              child: _TextCounter(),
                            ),
                          ],
                        ),
                        sheetBelow: SnappingSheetContent(
                          draggable: true,
                          childScrollController: isStretchedTextField
                              ? chatCubit.textInputScrollController
                              : null,
                          child: Container(
                            color: theme.canvasColor,
                            child: _InputTextField(key: chatCubit.textInputKey),
                          ),
                        ),
                      ),
                    );
                  }),
                Container(
                  color: theme.canvasColor,
                  child: Column(
                    key: chatCubit.bottomTextAreaKey,
                    children: [
                      Builder(builder: (context) {
                        return textInputFocused &&
                                chatCubit.state.attachedPictures.isNotEmpty
                            ? const Padding(
                                padding: EdgeInsets.fromLTRB(
                                  AppConstants.horizontalScreenPadding,
                                  0.0,
                                  AppConstants.horizontalScreenPadding,
                                  8.0,
                                ),
                                child: AttachedPictures(),
                              )
                            : const SizedBox.shrink();
                      }),
                      Builder(builder: (context) {
                        final bool canAttachPicture = chatCubit.canAttachPictureTo();
                        final int inputTextLength = context
                            .select((ChatCubit cubit) => cubit.state.inputTextLength);

                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppConstants.horizontalScreenPadding,
                            textInputFocused ? 0.0 : 10.0,
                            AppConstants.horizontalScreenPadding,
                            8.0,
                          ),
                          child: Row(
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
                                  if ((inputTextLength == 0 || textInputFocused) &&
                                      attachedPictures.isNotEmpty &&
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
                                            if (inputTextLength == 0) {
                                              chatCubit.startRecordingAudio(context);
                                            }
                                          },
                                          child: Opacity(
                                            opacity: inputTextLength == 0 ? 1.0 : 0.4,
                                            child: Assets.vectors.microphone
                                                .svg(width: AppConstants.iconSize),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              if (!textInputFocused)
                                Builder(builder: (context) {
                                  final int inputTextLength = context.select(
                                      (ChatCubit cubit) =>
                                          cubit.state.inputTextLength);
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: GestureDetector(
                                          onVerticalDragStart: (_) {
                                            chatCubit.setTextInputFocus(true);
                                          },
                                          onTap: () {
                                            chatCubit.setTextInputFocus(true);
                                          },
                                          child: inputTextLength > 0
                                              ? Text(
                                                  chatCubit.textInputEditingController
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
                                                  SFortunica.of(context)
                                                      .typeMessageFortunica,
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
                                  );
                                }),
                              Builder(builder: (context) {
                                final isSendButtonEnabled = context.select(
                                    (ChatCubit cubit) =>
                                        cubit.state.isSendButtonEnabled);
                                final int inputTextLength = context.select(
                                    (ChatCubit cubit) => cubit.state.inputTextLength);

                                if (attachedPictures.isNotEmpty && !textInputFocused) {
                                  return GestureDetector(
                                    onTap: () {
                                      chatCubit.setTextInputFocus(true);
                                    },
                                    child: Stack(
                                      children: [
                                        Assets.vectors.attach.svg(
                                          width: AppConstants.iconSize,
                                          height: AppConstants.iconSize,
                                          color: theme.iconTheme.color,
                                        ),
                                        Positioned(
                                          top: 0.0,
                                          right: 0.0,
                                          child: Container(
                                            height: 8.0,
                                            width: 8.0,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.promotion,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else if (inputTextLength == 0 &&
                                    attachedPictures.isEmpty &&
                                    isAudioQuestion &&
                                    !textInputFocused) {
                                  return AppIconGradientButton(
                                    onTap: () =>
                                        chatCubit.startRecordingAudio(context),
                                    icon: Assets.vectors.microphone.path,
                                    iconColor: theme.backgroundColor,
                                  );
                                } else if (textInputFocused) {
                                  return Opacity(
                                    opacity: isSendButtonEnabled ? 1.0 : 0.4,
                                    child: AppIconGradientButton(
                                      onTap: () {
                                        if (isSendButtonEnabled) {
                                          FocusScope.of(context).unfocus();
                                          chatCubit
                                              .sendAnswer(ChatContentType.textMedia);
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
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ],
            );
          });
        }
      ),
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

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
      ),
      child: Scrollbar(
        thickness: scrollbarThickness,
        controller: chatCubit.textInputScrollController,
        thumbVisibility: true,
        child: TextField(
          scrollController: chatCubit.textInputScrollController,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          scrollPhysics: const ClampingScrollPhysics(),
          controller: chatCubit.textInputEditingController,
          focusNode: chatCubit.textInputFocusNode,
          maxLines: isCollapsed ? 5 : null,
          minLines: isCollapsed ? 1 : null,
          expands: !isCollapsed,
          style: style,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: SFortunica.of(context).typeMessageFortunica,
            hintStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.shadowColor,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
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
        height: textCounterHeight + 1,
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
          height: textCounterHeight,
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
