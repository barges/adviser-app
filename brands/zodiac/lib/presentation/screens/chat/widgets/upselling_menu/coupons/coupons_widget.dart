import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:zodiac/data/models/coupons/coupons_category.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/chat/chat_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/category_menu_item_widget.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/coupons/coupons_cubit.dart';
import 'package:zodiac/presentation/screens/chat/widgets/upselling_menu/upselling_header_widget.dart';

class CouponsWidget extends StatelessWidget {
  const CouponsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider(
      create: (_) => CouponsCubit(),
      child: Builder(builder: (context) {
        final CouponsCubit couponsCubit = context.read<CouponsCubit>();

        final List<CouponsCategory>? couponsCategories =
            context.select((ChatCubit cubit) => cubit.state.couponsCategories);
        final int selectedCategoryIndex = context
            .select((CouponsCubit cubit) => cubit.state.selectedCategoryIndex);

        if (couponsCategories != null) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(color: theme.canvasColor),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding),
                  child: Column(
                    children: [
                      UpsellingHeaderWidget(
                        title: SZodiac.of(context).sendCouponZodiac,
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Builder(builder: (context) {
                        const int limit = 5;

                        List<String> splittedString = SZodiac.of(context)
                            .youCanSendNCouponsPerDayZodiac(limit)
                            .split(limit.toString());

                        splittedString.insert(1, limit.toString());

                        return RichText(
                          text: TextSpan(
                              children: splittedString.map((e) {
                            TextStyle? style;
                            if (int.tryParse(e) == null) {
                              style = theme.textTheme.bodySmall?.copyWith(
                                fontSize: 14.0,
                                color: theme.shadowColor,
                              );
                            } else {
                              style = theme.textTheme.displaySmall?.copyWith(
                                fontSize: 14.0,
                                color: theme.shadowColor,
                              );
                            }
                            return TextSpan(
                              text: e,
                              style: style,
                            );
                          }).toList()),
                        );
                      }),
                      const SizedBox(
                        height: 12.0,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: AppConstants.horizontalScreenPadding,
                    ),
                    ...couponsCategories
                        .mapIndexed(
                          (index, element) => CategoryMenuItemWidget(
                            title: (couponsCategories[index].label ?? '')
                                    .capitalize ??
                                '',
                            isSelected: selectedCategoryIndex == index,
                            onTap: () =>
                                couponsCubit.setSelectedCategoryIndex(index),
                          ),
                        )
                        .toList(),
                    const SizedBox(
                      width: AppConstants.horizontalScreenPadding,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }
}
