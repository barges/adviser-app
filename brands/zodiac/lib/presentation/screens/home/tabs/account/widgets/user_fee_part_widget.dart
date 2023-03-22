import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/home/home_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/change_price_bottomsheet.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/tile_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';

class UserFeePartWidget extends StatelessWidget {
  const UserFeePartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ZodiacAccountCubit zodiacAccountCubit =
        context.read<ZodiacAccountCubit>();
    final UserDetails? userInfo =
        context.select((ZodiacAccountCubit cubit) => cubit.state.userInfo);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        color: Theme.of(context).canvasColor,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(left: AppConstants.horizontalScreenPadding),
        child: Column(
          children: [
            Builder(builder: (context) {
              final bool chatsEnabled = context.select(
                  (ZodiacAccountCubit cubit) => cubit.state.chatsEnabled);
              return TileWidget(
                title: SZodiac.of(context)
                    .pricePerMinZodiac(userInfo?.chatFee ?? '0.0'),
                iconSVGPath: Assets.zodiac.chatFee.path,
                onChanged: zodiacAccountCubit.updateChatsEnabled,
                widget: GestureDetector(
                  onTap: () {
                    final HomeCubit homeCubit = context.read<HomeCubit>();
                    final double fee = userInfo?.chatFee ?? 0.0;
                    changePriceBottomsheet(
                      ///TODO: need check
                      context: //homeCubit.scaffoldKey.currentContext ??
                          context,
                      integerNumberPart: fee.floor(),
                      fractionalNumberPart: ((fee * 100) % 100).toInt(),
                      onDone: zodiacAccountCubit.changeChatsPrice,
                    );
                  },
                  child: Text(
                    SZodiac.of(context).changeZodiac,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 13.0,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
                initSwitcherValue: chatsEnabled,
              );
            }),
            const Divider(
              height: 1.0,
            ),
            Builder(builder: (context) {
              final bool callsEnabled = context.select(
                  (ZodiacAccountCubit cubit) => cubit.state.callsEnabled);
              return TileWidget(
                title: SZodiac.of(context)
                    .pricePerMinZodiac(userInfo?.callFee ?? '0.0'),
                iconSVGPath: Assets.zodiac.callFee.path,
                onChanged: zodiacAccountCubit.updateCallsEnabled,
                widget: GestureDetector(
                  onTap: () {
                    final HomeCubit homeCubit = context.read<HomeCubit>();
                    final double fee = userInfo?.callFee ?? 0.0;

                    ///TODO: need check
                    changePriceBottomsheet(
                      context: //homeCubit.scaffoldKey.currentContext ??
                          context,
                      integerNumberPart: fee.floor(),
                      fractionalNumberPart: ((fee * 100) % 100).toInt(),
                      onDone: zodiacAccountCubit.changeCallsPrice,
                    );
                  },
                  child: Text(
                    SZodiac.of(context).changeZodiac,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 13.0,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ),
                initSwitcherValue: callsEnabled,
              );
            }),
            const Divider(
              height: 1.0,
            ),
            Builder(builder: (context) {
              final bool randomCallsEnabled = context.select(
                  (ZodiacAccountCubit cubit) => cubit.state.randomCallsEnabled);
              return TileWidget(
                title: SZodiac.of(context)
                    .pricePerMinZodiac(userInfo?.randomCallFee ?? '1.99'),
                iconSVGPath: Assets.zodiac.callFee.path,
                onChanged: zodiacAccountCubit.updateRandomCallsEnabled,
                widget: Text(
                  SZodiac.of(context).lowestRateZodiac,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 13.0,
                        color: Theme.of(context).shadowColor,
                      ),
                ),
                initSwitcherValue: randomCallsEnabled,
              );
            }),
          ],
        ),
      ),
    );
  }
}
