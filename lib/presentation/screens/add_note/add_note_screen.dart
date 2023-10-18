import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_constants.dart';
import '../../../data/models/app_error/app_error.dart';
import '../../../generated/assets/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../infrastructure/di/inject_config.dart';
import '../../../main_cubit.dart';
import '../../common_widgets/appbar/wide_app_bar.dart';
import '../../common_widgets/buttons/app_icon_button.dart';
import '../../common_widgets/messages/app_error_widget.dart';
import 'add_note_cubit.dart';
import 'widgets/old_note_date_widget.dart';

class AddNoteScreen extends StatelessWidget {
  final AddNoteScreenArguments addNoteScreenArguments;

  const AddNoteScreen({
    Key? key,
    required this.addNoteScreenArguments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddNoteCubit(
        mainCubit: fortunicaGetIt.get<MainCubit>(),
        customerID: addNoteScreenArguments.customerId,
        noteChanged: addNoteScreenArguments.noteChanged,
        oldNote: addNoteScreenArguments.oldNote,
      ),
      child: Builder(builder: (context) {
        AddNoteCubit addNoteCubit = context.read<AddNoteCubit>();
        bool isNoteNew =
            context.select((AddNoteCubit cubit) => cubit.state.isNoteNew);
        final bool isOnline = context.select(
            (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
        final AppError appError =
            context.select((MainCubit cubit) => cubit.state.appError);

        return Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: WideAppBar(
            bottomWidget: Text(
              isNoteNew
                  ? SFortunica.of(context).addNoteFortunica
                  : SFortunica.of(context).editNoteFortunica,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            topRightWidget: Opacity(
              opacity: isOnline ? 1.0 : 0.4,
              child: AppIconButton(
                icon: Assets.vectors.check.path,
                onTap: isOnline
                    ? () => addNoteCubit.addNoteToCustomer(context)
                    : () {},
              ),
            ),
          ),
          body: Column(
            children: [
              AppErrorWidget(
                errorMessage: isOnline
                    ? ''
                    : SFortunica.of(context)
                        .youDontHaveAnInternetConnectionFortunica,
              ),
              if (isOnline)
                AppErrorWidget(
                  errorMessage: appError.getMessage(context),
                  close: addNoteCubit.closeErrorWidget,
                ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isNoteNew
                          ? const SizedBox.shrink()
                          : OldNoteDateWidget(
                              updatedAt: addNoteScreenArguments.updatedAt,
                            ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: addNoteCubit.noteController,
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
                            textCapitalization: TextCapitalization.sentences,
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
                      //const AttachedPicturesListWidget(),
                    ]),
              ),
            ],
          ),
          //floatingActionButton: const AttachNewPictureCircleButtonWidget(),
        );
      }),
    );
  }
}

class AddNoteScreenArguments {
  final String customerId;
  final String? oldNote;
  final DateTime? updatedAt;
  final VoidCallback noteChanged;

  AddNoteScreenArguments({
    required this.customerId,
    required this.noteChanged,
    this.oldNote,
    this.updatedAt,
  });
}
