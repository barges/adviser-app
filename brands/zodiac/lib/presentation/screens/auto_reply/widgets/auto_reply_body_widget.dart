import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/screens/auto_reply/widgets/auto_reply_list_widget.dart';
import 'package:zodiac/presentation/screens/auto_reply/widgets/select_time_buttons_part_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class AutoReplyBodyWidget extends StatelessWidget {
  final bool autoReplyEnabled;
  const AutoReplyBodyWidget({
    Key? key,
    required this.autoReplyEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: !autoReplyEnabled,
          child: Opacity(
            opacity: autoReplyEnabled ? 1.0 : 0.6,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: AppConstants.horizontalScreenPadding),
              child: Column(
                children: [
                  AutoReplyListWidget(),
                  SizedBox(
                    height: 24.0,
                  ),
                  SelectTimeButtonsPartWidget(),
                ],
              ),
            ),
          ),
        ),
        Builder(builder: (context) {
          final bool internetConnectionIsAvailable = context.select(
              (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);

          if (internetConnectionIsAvailable) {
            final ZodiacMainCubit zodiacMainCubit =
                context.read<ZodiacMainCubit>();

            final AppError appError =
                context.select((ZodiacMainCubit cubit) => cubit.state.appError);

            return AppErrorWidget(
              errorMessage: appError.getMessage(context),
              close: zodiacMainCubit.clearErrorMessage,
            );
          } else {
            return AppErrorWidget(
                errorMessage: SZodiac.of(context).noInternetConnectionZodiac);
          }
        })
      ],
    );
  }
}
