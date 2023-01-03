import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/add_note/add_note_cubit.dart';
import 'package:shared_advisor_interface/extensions.dart';

class OldNoteDateWidget extends StatelessWidget {
  const OldNoteDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddNoteCubit addNoteCubit = context.read<AddNoteCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
        vertical: 12.0,
      ),
      child: Text(
        addNoteCubit.arguments.updatedAt?.parseDateTimePattern12 ?? '',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).shadowColor,
            ),
      ),
    );
  }
}
