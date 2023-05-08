import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';

class DownButtonWidget extends StatelessWidget {
  final int unreadCount;

  const DownButtonWidget({
    Key? key,
    required this.unreadCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: context.read<ChatCubit>().animateToStartChat,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 42.0,
            width: 42.0,
            decoration: BoxDecoration(
                color: theme.canvasColor,
                borderRadius: BorderRadius.circular(
                  AppConstants.buttonRadius,
                ),
                border: Border.all(
                  width: 1.0,
                  color: theme.hintColor,
                )),
            child: Center(
              child: Assets.vectors.arrowDown.svg(
                height: AppConstants.iconSize,
                width: AppConstants.iconSize,
                color: theme.primaryColor,
              ),
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              top: -8.0,
              child: Container(
                height: 16.0,
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.buttonRadius),
                  color: theme.primaryColorLight,
                ),
                child: Center(
                  child: Text(
                    unreadCount.toString(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 12.0,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
