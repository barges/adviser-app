import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class TransparentAppBar extends StatelessWidget {
  final bool needShowInternetError;
  const TransparentAppBar({
    Key? key,
    this.needShowInternetError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color hoverColor = Theme.of(context).hoverColor;

    return Builder(builder: (context) {
      final ZodiacMainCubit zodiacMainCubit = context.read<ZodiacMainCubit>();

      return Column(
        children: [
          Container(
            height: 96.0,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.mirror,
                colors: [
                  hoverColor.withOpacity(.5),
                  hoverColor.withOpacity(.21),
                  hoverColor.withOpacity(.0)
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: AppIconButton(
                icon: Assets.vectors.arrowLeft.path,
                onTap: context.pop,
              ),
            ),
          ),
          Builder(builder: (context) {
            final bool isOnline = context.select(
                (MainCubit cubit) => cubit.state.internetConnectionIsAvailable);
            final AppError appError =
                context.select((ZodiacMainCubit cubit) => cubit.state.appError);

            if (isOnline) {
              return AppErrorWidget(
                errorMessage: appError.getMessage(context),
                close: zodiacMainCubit.clearErrorMessage,
              );
            } else if (needShowInternetError) {
              return AppErrorWidget(
                errorMessage: SZodiac.of(context).noInternetConnectionZodiac,
              );
            } else {
              return const SizedBox.shrink();
            }
          })
        ],
      );
    });
  }
}
