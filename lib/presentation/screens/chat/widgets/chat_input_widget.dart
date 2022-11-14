import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';

class ChatInputWidget extends StatelessWidget {
  const ChatInputWidget({
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
    return Container(
      color: Get.theme.canvasColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 0.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: null,
              child: Assets.vectors.photo.svg(width: AppConstants.iconSize),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      context.select(
                          (ChatCubit cubit) => cubit.state.inputTextLength);
                      final ChatCubit chatCubit = context.read<ChatCubit>();
                      final span = TextSpan(
                          text: chatCubit.textEditingController.text,
                          style: style);
                      final tp = TextPainter(
                          text: span, textDirection: TextDirection.ltr);
                      tp.layout(maxWidth: constraints.maxWidth);
                      final numLines = tp.computeLineMetrics().length;

                      return Padding(
                        padding: EdgeInsets.only(right: numLines > 10 ? 1 : 0),
                        child: TextField(
                          controller: chatCubit.textEditingController,
                          maxLines: numLines > 10 ? 10 : null,
                          style: style,
                          decoration: InputDecoration(
                            isCollapsed: true,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: S.of(context).typemessage,
                            hintStyle: Get.textTheme.bodySmall?.copyWith(
                              color: Get.theme.shadowColor,
                              fontSize: 15.0,
                              height: 0.97,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Builder(builder: (context) {
              final int inputTextLength = context
                  .select((ChatCubit cubit) => cubit.state.inputTextLength);
              return Row(
                children: [
                  if (inputTextLength == 0)
                    GestureDetector(
                      onTap: () => chatCubit.startRecordingAudio(),
                      child: Assets.images.microphoneBig.image(
                        height: AppConstants.iconButtonSize,
                        width: AppConstants.iconButtonSize,
                      ),
                    ),
                  if (inputTextLength > 0)
                    GestureDetector(
                      onTap: () => chatCubit.sendText(),
                      child: Assets.images.send.image(
                        width: AppConstants.iconButtonSize,
                      ),
                    )
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
