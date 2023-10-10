import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_cubit.dart';
import 'package:zodiac/presentation/screens/auto_reply/widgets/show_time_picker_dialog.dart';

class SelectTimeButtonWidget extends StatefulWidget {
  final String title;

  const SelectTimeButtonWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<SelectTimeButtonWidget> createState() => _SelectTimeButtonWidgetState();
}

class _SelectTimeButtonWidgetState extends State<SelectTimeButtonWidget> {
  bool isSelecting = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final AutoReplyCubit autoReplyCubit = context.read<AutoReplyCubit>();

    return GestureDetector(
      onTap: () => showTimePickerDialog(
        context,
        autoReplyCubit.setSingleTime,
      ),
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
}
