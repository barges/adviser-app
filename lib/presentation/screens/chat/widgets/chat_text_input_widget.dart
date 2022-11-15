import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/chat_attached_pictures.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class ChatTextInputWidget extends StatelessWidget {
  const ChatTextInputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final List<File> attachedPics =
        context.select((ChatCubit cubit) => cubit.state.attachedPics);
    final isAttachedPics = attachedPics.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
      child: Column(
        children: [
          if (isAttachedPics) const _InputTextField(),
          if (isAttachedPics)
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
              crossAxisAlignment: isAttachedPics || inputTextLength == 0
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (attachedPics.length < AppConstants.maxAttachedPics) {
                      showPickImageAlert(
                        context: context,
                        setImage: chatCubit.attachPicture,
                      );
                    }
                  },
                  child: Opacity(
                      opacity:
                          attachedPics.length < AppConstants.maxAttachedPics
                              ? 1.0
                              : 0.4,
                      child: Assets.vectors.photo
                          .svg(width: AppConstants.iconSize)),
                ),
                if (isAttachedPics) const Spacer(),
                if (!isAttachedPics)
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: _InputTextField(),
                    ),
                  ),
                Builder(builder: (context) {
                  final int inputTextLength = context
                      .select((ChatCubit cubit) => cubit.state.inputTextLength);
                  return Row(
                    children: [
                      if (inputTextLength == 0 && !isAttachedPics)
                        GestureDetector(
                          onTap: () => chatCubit.startRecordingAudio(),
                          child: Assets.images.microphoneBig.image(
                            height: AppConstants.iconButtonSize,
                            width: AppConstants.iconButtonSize,
                          ),
                        ),
                      if (inputTextLength > 0 || isAttachedPics)
                        GestureDetector(
                          onTap: () => chatCubit.sendTextMedia(),
                          child: Assets.images.send.image(
                            width: AppConstants.iconButtonSize,
                          ),
                        )
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
    final TextStyle? style = Get.textTheme.bodySmall?.copyWith(
      color: Get.theme.hoverColor,
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
        return Padding(
          padding: EdgeInsets.only(right: textNumLines > 10 ? 1 : 0),
          child: Scrollbar(
            controller: chatCubit.textInputScrollController,
            thumbVisibility: true,
            interactive: true,
            child: TextField(
              scrollController: chatCubit.textInputScrollController,
              controller: chatCubit.textEditingController,
              maxLines: textNumLines > 10 ? 10 : null,
              style: style,
              decoration: InputDecoration(
                isCollapsed: true,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: S.of(context).typemessage,
                hintStyle: Get.textTheme.bodySmall?.copyWith(
                  color: Get.theme.shadowColor,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
