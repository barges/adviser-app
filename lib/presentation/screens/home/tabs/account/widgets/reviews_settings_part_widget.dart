import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/tile_widget.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';

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
            title: S.of(context).balanceTransactions,
            iconSVGPath: Assets.vectors.transactions.path,
            onTap: () {
              Get.toNamed(AppRoutes.balanceAndTransactions);
            },
          ),
          const Divider(
            height: 1.0,
          ),
          Builder(builder: (context) {
            final UserStatus? currentStatus =
                context.select((HomeCubit cubit) => cubit.state.userStatus);
            return TileWidget(
              onTap: accountCubit.openSettingsUrl,
              title: S.of(context).settings,
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
