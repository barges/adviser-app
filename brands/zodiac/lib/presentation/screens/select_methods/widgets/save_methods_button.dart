import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/select_methods/select_methods_cubit.dart';

class SaveMethodsButton extends StatelessWidget {
  const SaveMethodsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SelectMethodsCubit selectMethodsCubit =
        context.read<SelectMethodsCubit>();

    final int? mainMethodId =
        context.select((SelectMethodsCubit cubit) => cubit.state.mainMethodId);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding,
          vertical: 12.0,
        ),
        child: AppElevatedButton(
          title: SZodiac.of(context).saveZodiac,
          onPressed: mainMethodId != null
              ? () => selectMethodsCubit.saveChanges(context)
              : null,
        ),
      ),
    );
  }
}
