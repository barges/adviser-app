import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/show_pick_image_alert.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/add_note/add_note_cubit.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddNoteCubit(),
      child: Builder(builder: (context) {
        AddNoteCubit addNoteCubit = context.read<AddNoteCubit>();
        List<String> imagesPaths =
            context.select((AddNoteCubit cubit) => cubit.state.imagesPaths);
        bool isNoteNew =
            context.select((AddNoteCubit cubit) => cubit.state.isNoteNew);
        return Scaffold(
          appBar: WideAppBar(
            bottomWidget: Text(
              isNoteNew ? S.of(context).addNote : S.of(context).editNote,
              style: Theme.of(context).textTheme.headlineMedium,
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
              isNoteNew
                  ? const SizedBox.shrink()
                  : Text(
                      addNoteCubit.arguments.updatedAt!.parseDateTimePattern2,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).shadowColor,
                          ),
                    ),
              /**
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Builder(builder: (context) {
                    bool hadTitle = context
                        .select((AddNoteCubit cubit) => cubit.state.hadTitle);
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
                          child: Text(S.of(context).title,
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).shadowColor)));
                    }
                  }),
                ),
              */
              TextField(
                controller: addNoteCubit.noteController,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontWeight: FontWeight.w400),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: true,
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Center(
                  child: Builder(builder: (context) {
                    logger.d(imagesPaths);
                    return (imagesPaths.isNotEmpty)
                        ? Column(
                            children: List.generate(
                                imagesPaths.length,
                                (index) => Builder(builder: (context) {
                                      final String imagesPath = context.select(
                                          (AddNoteCubit cubit) =>
                                              cubit.state.imagesPaths[index]);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: Image.file(
                                          File(imagesPath),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    })),
                          )
                        : const SizedBox.shrink();
                  }),
                ),
              )
            ]),
          ),
          /**
            floatingActionButton: GestureDetector(
              onTap: () {
                showPickImageAlert(
                    context: context,
                    setImage: addNoteCubit.attachPicture,
                    setMultiImage: addNoteCubit.attachMultiPictures);
              },
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
          */
        );
      }),
    );
  }
}
