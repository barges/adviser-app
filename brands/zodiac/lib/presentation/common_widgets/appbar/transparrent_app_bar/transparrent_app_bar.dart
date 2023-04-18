import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/data/models/app_error/app_error.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/presentation/common_widgets/appbar/transparrent_app_bar/transparrent_app_bar_cubit.dart';
import 'package:zodiac/presentation/common_widgets/messages/app_error_widget.dart';
import 'package:zodiac/zodiac_main_cubit.dart';

class TransparentAppBar extends StatelessWidget {
  const TransparentAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color hoverColor = Theme.of(context).hoverColor;

    return BlocProvider(
      create: (context) =>
          TransparrentAppBarCubit(zodiacGetIt.get<ZodiacMainCubit>()),
      child: Builder(builder: (context) {
        final TransparrentAppBarCubit transparrentAppBarCubit =
            context.read<TransparrentAppBarCubit>();
        final AppError appError =
            context.select((ZodiacMainCubit cubit) => cubit.state.appError);
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
              final bool isOnline = context.select((MainCubit cubit) =>
                  cubit.state.internetConnectionIsAvailable);
              if (isOnline) {
                return AppErrorWidget(
                  errorMessage: appError.getMessage(context),
                  close: transparrentAppBarCubit.clearErrorMessage,
                );
              } else {
                return AppErrorWidget(
                  errorMessage: SZodiac.of(context).noInternetConnectionZodiac,
                  isRequired: true,
                );
              }
            })
          ],
        );
      }),
    );
  }
}
