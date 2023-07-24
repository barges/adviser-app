import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';

class CounterWidget extends StatefulWidget {
  final int count;
  final bool limitReached;
  final int? couponId;

  const CounterWidget({
    Key? key,
    required this.count,
    required this.limitReached,
    this.couponId,
  }) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool minimalCount = widget.count == 1;
    final ZodiacAccountCubit accountCubit = context.read<ZodiacAccountCubit>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        color: theme.canvasColor,
      ),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Opacity(
            opacity: minimalCount ? 0.6 : 1.0,
            child: AppIconButton(
              icon: Assets.vectors.minus.path,
              color: theme.primaryColor,
              onTap: !minimalCount
                  ? () => accountCubit.setCouponCounter(
                      widget.couponId, widget.count - 1)
                  : null,
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            widget.count.toString(),
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16.0),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Opacity(
            opacity: widget.limitReached ? 0.6 : 1.0,
            child: AppIconButton(
              icon: Assets.vectors.plus.path,
              color: theme.primaryColor,
              onTap: !widget.limitReached
                  ? () => accountCubit.setCouponCounter(
                      widget.couponId, widget.count + 1)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
