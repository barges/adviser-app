import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:fortunica/fortunica_main_cubit.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:fortunica/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:fortunica/presentation/screens/add_note/add_note_cubit.dart';
import 'package:fortunica/presentation/screens/add_note/widgets/old_note_date_widget.dart';

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
        mainCubit: fortunicaGetIt.get<FortunicaMainCubit>(),
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
            context.select((FortunicaMainCubit cubit) => cubit.state.appError);

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
  final String? updatedAt;
  final VoidCallback noteChanged;

  AddNoteScreenArguments({
    required this.customerId,
    required this.noteChanged,
    this.oldNote,
    this.updatedAt,
  });
}
