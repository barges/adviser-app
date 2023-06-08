import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:snapping_sheet_2/snapping_sheet.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/grabbing_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/text_input_field/replied_message_widget.dart';

const constGrabbingHeight = 16.0;
const repliedMessageHeight = 48.0;
const stretchedTextFieldTopPadding = 21.0;
const scrollbarThickness = 4.0;
const constBottomPartTextInputHeight = 52.0;

class ChatTextInputWidget extends StatelessWidget {
  final ChatMessageModel? repliedMessage;

  const ChatTextInputWidget({
    Key? key,
    this.repliedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (prev, current) =>
          prev.inputTextLength != current.inputTextLength ||
          prev.repliedMessage != current.repliedMessage,
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
      child: Builder(builder: (context) {
        final bool textInputFocused =
            context.select((ChatCubit cubit) => cubit.state.textInputFocused);

        final bool isStretchedTextField = context
            .select((ChatCubit cubit) => cubit.state.isStretchedTextField);

        final bool hasRepliedMessage = repliedMessage != null;

        final double bottomPartTextInputHeight = hasRepliedMessage
            ? constBottomPartTextInputHeight + repliedMessageHeight
            : constBottomPartTextInputHeight;

        final double repliedHeight =
            hasRepliedMessage ? repliedMessageHeight / 2 : 0.0;

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
                      MediaQueryData.fromView(View.of(context))
                          .viewPadding
                          .top -
                      MediaQueryData.fromView(View.of(context))
                          .viewInsets
                          .bottom -
                      bottomPartTextInputHeight -
                      (AppConstants.appBarHeight / 2) -
                      stretchedTextFieldTopPadding;

                  return Flexible(
                    child: SnappingSheet(
                      grabbingHeight: constGrabbingHeight +
                          (hasRepliedMessage ? repliedMessageHeight : 0.0),
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
                      controller: chatCubit.snappingSheetController,
                      initialSnappingPosition: SnappingPosition.pixels(
                        positionPixels: textInputHeight +
                            constGrabbingHeight * 2 +
                            (hasRepliedMessage ? repliedHeight : 0.0),
                      ),
                      snappingPositions: [
                        SnappingPosition.pixels(
                          positionPixels: textInputHeight +
                              constGrabbingHeight * 2 +
                              (hasRepliedMessage ? repliedHeight : 0.0),
                        ),
                        SnappingPosition.pixels(
                          positionPixels: h +
                              constGrabbingHeight +
                              (hasRepliedMessage ? repliedMessageHeight : 0.0),
                        ),
                      ],
                      grabbing: GrabbingWidget(
                        repliedMessage: repliedMessage,
                      ),
                      sheetBelow: SnappingSheetContent(
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
                height: textInputFocused
                    ? constBottomPartTextInputHeight
                    : bottomPartTextInputHeight +
                        (textInputFocused
                            ? 0.0
                            : MediaQuery.of(context).padding.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!textInputFocused && hasRepliedMessage)
                      RepliedMessageWidget(),
                    Builder(builder: (context) {
                      return Container(
                        height: constBottomPartTextInputHeight,
                        padding: EdgeInsets.fromLTRB(
                          AppConstants.horizontalScreenPadding,
                          textInputFocused ? 0.0 : 10.0,
                          textInputFocused
                              ? AppConstants.horizontalScreenPadding
                              : 14.0,
                          8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: AppConstants.iconButtonSize,
                                    width: AppConstants.iconButtonSize,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.buttonRadius),
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    child: Center(
                                      child: Assets.vectors.plusRounded.svg(
                                        width: AppConstants.iconSize,
                                        height: AppConstants.iconSize,
                                        color: theme.iconTheme.color,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showPickImageAlert(
                                      context: context,
                                      setImage: chatCubit.sendImage,
                                    );
                                  },
                                  child: Assets.vectors.gallery.svg(
                                    width: AppConstants.iconSize,
                                    height: AppConstants.iconSize,
                                    color: theme.iconTheme.color,
                                  ),
                                )
                              ],
                            ),
                            if (!textInputFocused)
                              Builder(builder: (context) {
                                final String text =
                                    chatCubit.textInputEditingController.text;
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
                                        child: text.isNotEmpty
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
                                                SZodiac.of(context)
                                                    .typeMessageZodiac,
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
                            if (!textInputFocused)
                              GestureDetector(
                                onTap: () {},
                                child: Assets.zodiac.vectors.emoji.svg(
                                  width: AppConstants.iconSize,
                                  height: AppConstants.iconSize,
                                  color: theme.iconTheme.color,
                                ),
                              ),
                            Builder(builder: (context) {
                              final isSendButtonEnabled = context.select(
                                  (ChatCubit cubit) =>
                                      cubit.state.isSendButtonEnabled);

                              if (!(!isSendButtonEnabled &&
                                  chatCubit.enterRoomData
                                          ?.isAvailableAudioMessage ==
                                      true &&
                                  !textInputFocused)) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: AppIconGradientButton(
                                    onTap: () {
                                      chatCubit.startRecordingAudio(context);
                                    },
                                    icon: Assets.vectors.microphone.path,
                                    iconColor: theme.backgroundColor,
                                  ),
                                );
                              } else if (textInputFocused) {
                                return Opacity(
                                  opacity: isSendButtonEnabled ? 1.0 : 0.4,
                                  child: AppIconGradientButton(
                                    onTap: () {
                                      if (isSendButtonEnabled) {
                                        chatCubit.sendMessageToChat();
                                        if (!chatCubit.state.chatIsActive &&
                                            !chatCubit
                                                .state.offlineSessionIsActive) {
                                          FocusScope.of(context).unfocus();
                                        }
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
                    }),
                  ],
                ),
              ),
            ],
          );
        });
      }),
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
            hintText: SZodiac.of(context).typeMessageZodiac,
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
