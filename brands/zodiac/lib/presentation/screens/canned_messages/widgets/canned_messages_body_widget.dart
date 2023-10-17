import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_cubit.dart';
import 'package:zodiac/presentation/screens/canned_messages/canned_messages_screen.dart';
import 'package:zodiac/presentation/screens/canned_messages/widgets/add_canned_message_widget.dart';
import 'package:zodiac/presentation/screens/canned_messages/widgets/canned_message_manager_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class CannedMessagesBodyWidget extends StatelessWidget {
  const CannedMessagesBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CannedMessagesCubit cannedMessagesCubit =
        context.read<CannedMessagesCubit>();
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () {
            return cannedMessagesCubit.loadData();
          },
          child: GestureDetector(
            onTap: FocusScope.of(context).unfocus,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(bottom: verticalInterval, top: 16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const AddCannedMessageWidget(),
                  CannedMessageManagerWidget(
                      key: cannedMessagesCubit.cannedMessageManagerKey),
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
