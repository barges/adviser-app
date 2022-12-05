import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_gradient_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/attached_pictures.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class ChatTextInputWidget extends StatelessWidget {
  const ChatTextInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final List<File> attachedPictures =
        context.select((ChatCubit cubit) => cubit.state.attachedPictures);
    final isAttachedPictures = attachedPictures.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
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
            final int inputTextLength = context
                .select((ChatCubit cubit) => cubit.state.inputTextLength);
            return Row(
              crossAxisAlignment: isAttachedPictures || inputTextLength == 0
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
                  final int inputTextLength = context
                      .select((ChatCubit cubit) => cubit.state.inputTextLength);
                  final bool isSendTextEnabled =
                      (inputTextLength >= AppConstants.minTextLength &&
                              inputTextLength <= AppConstants.maxTextLength) ||
                          attachedPictures.isNotEmpty;

                  return Row(
                    children: [
                      if (inputTextLength == 0 && !isAttachedPictures)
                        AppIconGradientButton(
                          onTap: () => chatCubit.startRecordingAudio(),
                          icon: Assets.vectors.microphone.path,
                          iconColor: Theme.of(context).backgroundColor,
                        ),
                      if (inputTextLength > 0 || isAttachedPictures)
                        Opacity(
                          opacity: isSendTextEnabled ? 1.0 : 0.4,
                          child: AppIconGradientButton(
                            onTap: () => isSendTextEnabled
                                ? chatCubit.sendTextMedia()
                                : null,
                            icon: Assets.vectors.send.path,
                            iconColor: Theme.of(context).backgroundColor,
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
          controller: chatCubit.textInputScrollController,
          thumbVisibility: true,
          interactive: true,
          child: TextField(
            scrollController: chatCubit.textInputScrollController,
            controller: chatCubit.textEditingController,
            maxLines: textNumLines > 10 ? 10 : null,
            style: style,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(right: textNumLines > 10 ? 4 : 0),
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