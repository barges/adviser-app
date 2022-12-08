import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/add_note/add_note_cubit.dart';

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
        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);

        return Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: WideAppBar(
            bottomWidget: Text(
              isNoteNew ? S.of(context).addNote : S.of(context).editNote,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            topRightWidget: Opacity(
              opacity: isOnline ? 1.0 : 0.4,
              child: AppIconButton(
                icon: Assets.vectors.check.path,
                onTap: isOnline ? addNoteCubit.addNoteToCustomer : () {},
              ),
            ),
          ),
          body: Column(
            children: [
              isOnline
                  ? const SizedBox.shrink()
                  : AppErrorWidget(
                      errorMessage: S.of(context).youDontHaveInternetConnection,
                      isRequired: true,
                    ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isNoteNew
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    AppConstants.horizontalScreenPadding,
                                vertical: 12.0,
                              ),
                              child: Text(
                                addNoteCubit
                                    .arguments.updatedAt!.parseDateTimePattern2,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).shadowColor,
                                    ),
                              ),
                            ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: addNoteCubit.noteController,
                            scrollController:
                                addNoteCubit.textFieldScrollController,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontWeight: FontWeight.w400),
                            keyboardType: TextInputType.multiline,
                            minLines: null,
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
                              contentPadding: EdgeInsets.only(
                                left: AppConstants.horizontalScreenPadding,
                                right: AppConstants.horizontalScreenPadding,
                                bottom: 12.0,
                              ),
                            ),
                          ),
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
                                              final String imagesPath =
                                                  context.select((AddNoteCubit
                                                          cubit) =>
                                                      cubit.state
                                                          .imagesPaths[index]);
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
            ],
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
