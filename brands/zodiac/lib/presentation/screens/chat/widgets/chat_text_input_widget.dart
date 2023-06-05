import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/chat_state.dart';

const grabbingHeight = 16.0;
const stretchedTextFieldTopPaddingF = 21.0;
const scrollbarThickness = 4.0;
const bottomPartTextInputHeight = AppConstants.appBarHeight;

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
      child: Builder(builder: (context) {
        final bool textInputFocused =
            context.select((ChatCubit cubit) => cubit.state.textInputFocused);
        final bool isStretchedTextField = context
            .select((ChatCubit cubit) => cubit.state.isStretchedTextField);

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
                      stretchedTextFieldTopPaddingF;

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
                      controller: chatCubit.snappingSheetController,
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
                      grabbing: Container(
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
                height: bottomPartTextInputHeight +
                    (textInputFocused
                        ? 0.0
                        : MediaQuery.of(context).padding.bottom),
                child: Column(
                  children: [
                    Builder(builder: (context) {
                      return Container(
                        height: bottomPartTextInputHeight,
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
                                      setImage: (image) =>
                                          chatCubit.sendImage(context, image),
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

                              if (!isSendButtonEnabled &&
                                  chatCubit.enterRoomData
                                          ?.isAvailableAudioMessage ==
                                      true &&
                                  !textInputFocused) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: AppIconGradientButton(
                                    onTap: () {
                                      ///TODO: Start record audio
                                      //chatCubit.startRecordingAudio(context);
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
