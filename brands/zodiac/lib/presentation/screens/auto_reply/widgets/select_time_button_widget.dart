import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zodiac/presentation/screens/auto_reply/widgets/show_time_picker_dialog.dart';

class SelectTimeButtonWidget extends StatefulWidget {
  final String title;
  final ValueSetter<String> setTime;
  final Stream? openPickerStream;

  const SelectTimeButtonWidget({
    Key? key,
    required this.title,
    required this.setTime,
    this.openPickerStream,
  }) : super(key: key);

  @override
  State<SelectTimeButtonWidget> createState() => _SelectTimeButtonWidgetState();
}

class _SelectTimeButtonWidgetState extends State<SelectTimeButtonWidget> {
  bool isSelecting = false;

  StreamSubscription? openPickerSubscription;

  @override
  void initState() {
    super.initState();
    openPickerSubscription = widget.openPickerStream?.listen((event) {
      _openTimePicker();
    });
  }

  @override
  void dispose() {
    openPickerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: _openTimePicker,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: isSelecting ? theme.primaryColorLight : theme.canvasColor,
        ),
        child: Center(
          child: Text(
            widget.title,
            style: isSelecting
                ? theme.textTheme.labelMedium?.copyWith(
                    fontSize: 15.0,
                    color: theme.primaryColor,
                  )
                : theme.textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  Future<void> _openTimePicker() async {
    setState(() {
      isSelecting = true;
    });
    await showTimePickerDialog(
      context,
      widget.setTime,
    );
    setState(() {
      isSelecting = false;
    });
  }
}
