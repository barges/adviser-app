import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../add_note_cubit.dart';

class TitlePartWidget extends StatelessWidget {
  const TitlePartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddNoteCubit addNoteCubit = context.read<AddNoteCubit>();
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Builder(builder: (context) {
        bool hadTitle =
            context.select((AddNoteCubit cubit) => cubit.state.hadTitle);
        if (hadTitle) {
          return TextField(
            controller: addNoteCubit.titleController,
            autofocus: true,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            scrollPadding: EdgeInsets.zero,
            cursorColor: Theme.of(context).hoverColor,
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          );
        } else {
          return GestureDetector(
              onTap: (() {
                addNoteCubit.addTitle();
              }),
              child: Text(SFortunica.of(context).titleFortunica,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).shadowColor)));
        }
      }),
    );
  }
}
