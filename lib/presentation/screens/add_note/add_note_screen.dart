import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/screens/add_note/add_note_cubit.dart';

class AddNoteScreen extends StatelessWidget {
  final String customerID;
  final String? oldNote;

  const AddNoteScreen({Key? key, required this.customerID, this.oldNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Get.put<AddNoteCubit>(
        AddNoteCubit(customerID, oldNote),
      ),
      child: Builder(builder: (context) {
        AddNoteCubit addNoteCubit = context.read<AddNoteCubit>();
        return Scaffold(
          appBar: WideAppBar(
            bottomWidget: Text(
              S.of(context).addNote,
              style: Get.textTheme.headlineMedium,
            ),
            topRightWidget: AppIconButton(
              icon: Assets.vectors.check.path,
              onTap: addNoteCubit.addNoteToCustomer,
            ),
          ),
          floatingActionButton: const CircleAvatar(backgroundColor: Colors.red,radius: 24.0,),
        );
      }),
    );
  }
}
