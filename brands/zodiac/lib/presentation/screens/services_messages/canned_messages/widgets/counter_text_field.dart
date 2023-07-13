import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/presentation/screens/services_messages/canned_messages/canned_messages_cubit.dart';

class CounterTextField extends StatefulWidget {
  final TextEditingController controller;
  const CounterTextField({
    super.key,
    required this.controller,
  });

  @override
  State<CounterTextField> createState() => _CounterTextFieldState();
}

class _CounterTextFieldState extends State<CounterTextField> {
  int _countSymbols = 0;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() => _countSymbols = widget.controller.text.length);
    });
    setState(() => _countSymbols = widget.controller.text.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text('$_countSymbols / $maximumMessageSymbols',
        textAlign: TextAlign.right,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 14.0,
          color: _countSymbols > 0 && _countSymbols <= maximumMessageSymbols
              ? AppColors.online
              : theme.errorColor,
        ));
  }
}
