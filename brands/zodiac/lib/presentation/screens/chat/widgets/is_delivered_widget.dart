import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

class IsDeliveredWidget extends StatefulWidget {
  final ChatMessageModel chatMessageModel;
  final Color color;
  final bool hideLoader;

  const IsDeliveredWidget({
    Key? key,
    required this.chatMessageModel,
    required this.color,
    required this.hideLoader,
  }) : super(key: key);

  @override
  State<IsDeliveredWidget> createState() => _IsDeliveredWidgetState();
}

class _IsDeliveredWidgetState extends State<IsDeliveredWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController loaderAnimationController;

  @override
  void initState() {
    super.initState();
    loaderAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
  }

  @override
  void dispose() {
    loaderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.chatMessageModel.isOutgoing
        ? widget.chatMessageModel.isRead
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 2.0,
                ),
                child: Assets.zodiac.vectors.isRead.svg(
                  height: 12.0,
                  width: 12.0,
                  color: widget.color,
                ),
              )
            : widget.chatMessageModel.isDelivered
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 2.0,
                    ),
                    child: Assets.zodiac.vectors.delivered.svg(
                      height: 12.0,
                      width: 12.0,
                      color: widget.color,
                    ),
                  )
                : !widget.hideLoader
                    ? Padding(
                        padding: const EdgeInsets.only(
                          left: 2.0,
                        ),
                        child: AnimatedBuilder(
                          animation: loaderAnimationController,
                          builder: (context, child) => Transform.rotate(
                            angle: loaderAnimationController.value * 2 * pi,
                            child: child,
                          ),
                          child: Assets.zodiac.vectors.loaderIcon.svg(
                            height: 12.0,
                            width: 12.0,
                            color: widget.color,
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
        : const SizedBox.shrink();
  }
}
