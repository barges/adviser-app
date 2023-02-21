import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_errors/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/appbar/wide_app_bar.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/add_note/add_note_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/add_note/widgets/old_note_date_widget.dart';

class AddNoteScreen extends StatelessWidget {
  const AddNoteScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddNoteCubit(getIt.get<MainCubit>()),
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
              AppErrorWidget(
                errorMessage: isOnline
                    ? ''
                    : S.of(context).youDontHaveAnInternetConnection,
                isRequired: true,
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
                          : const OldNoteDateWidget(),
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
