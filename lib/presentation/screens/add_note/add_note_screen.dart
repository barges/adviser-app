import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/add_note/add_note_cubit.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class AddNoteScreen extends StatelessWidget {

  const AddNoteScreen(
      {Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddNoteCubit(),
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: AppConstants.horizontalScreenPadding,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                DateFormat('MMM. d, yyyy').format(DateTime.now()),
                style: Get.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Get.theme.shadowColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  S.of(context).title,
                  style: Get.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Get.theme.shadowColor,
                  ),
                ),
              ),
              TextField(
                controller: addNoteCubit.controller,
                style: Get.textTheme.displayLarge
                    ?.copyWith(fontWeight: FontWeight.w400),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                scrollPadding: EdgeInsets.zero,
                cursorColor: Get.theme.hoverColor,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Center(
                child: Builder(builder: (context) {
                  final List<String> imagesPaths = context
                      .select((AddNoteCubit cubit) => cubit.state.imagesPaths);
                  return (imagesPaths.isNotEmpty)
                      ? Image.file(
                          File(imagesPaths[0]),
                          height: Get.height / 2,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox.shrink();
                }),
              )
            ]),
          ),
          floatingActionButton: GestureDetector(
            onTap: addNoteCubit.addImagesToNote,
            child: Container(
              height: 48.0,
              width: 48.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    colors: [AppColors.ctaGradient1, AppColors.ctaGradient2]),
              ),
              child: Assets.vectors.gallery.svg(fit: BoxFit.scaleDown),
            ),
          ),
        );
      }),
    );
  }
}
