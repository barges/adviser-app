import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_cubit.dart';

class CounterTextField extends StatelessWidget {
  final TextEditingController controller;
  late final ValueNotifier<int> countSymbolsNotifier =
      ValueNotifier(controller.text.length);
  CounterTextField({
    super.key,
    required this.controller,
  }) {
    controller.addListener(() {
      countSymbolsNotifier.value = controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder(
        valueListenable: countSymbolsNotifier,
        builder: (_, int value, __) {
          return Text('$value / $maximumMessageSymbols',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 14.0,
                color: value > 0 && value <= maximumMessageSymbols
                    ? AppColors.online
                    : theme.errorColor,
              ));
        });
  }
}
