import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:fortunica/data/models/user_info/user_status.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/screens/home/home_cubit.dart';
import 'package:fortunica/presentation/screens/home/tabs/account/account_cubit.dart';
import 'package:fortunica/presentation/screens/home/tabs/account/widgets/tile_widget.dart';

class ReviewsSettingsPartWidget extends StatelessWidget {
  const ReviewsSettingsPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccountCubit accountCubit = context.read<AccountCubit>();
    return Container(
      padding:
          const EdgeInsets.only(left: AppConstants.horizontalScreenPadding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Theme.of(context).canvasColor),
      child: Column(
        children: [
          TileWidget(
            title: SFortunica.of(context).balanceTransactionsFortunica,
            iconSVGPath: Assets.vectors.transactions.path,
            onTap: () {
              context.push(
                route: const FortunicaBalanceAndTransactions(),
              );
            },
          ),
          const Divider(
            height: 1.0,
          ),
          Builder(builder: (context) {
            final UserStatus? currentStatus =
                context.select((HomeCubit cubit) => cubit.state.userStatus);
            return TileWidget(
              onTap: () => accountCubit.openSettingsUrl(context),
              title: SFortunica.of(context).settingsFortunica,
              iconSVGPath: Assets.vectors.settings.path,
              withError:
                  currentStatus?.status == FortunicaUserStatus.legalBlock,
            );
          })
        ],
      ),
    );
  }
}
