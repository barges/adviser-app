import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';

/*class TransitionsTileWidget extends StatefulWidget {
  final List<PaymentInformation> items;
  final BalanceAndTransactionsCubit cubit;
  const TransitionsTileWidget({
    super.key,
    required this.items,
    required this.cubit,
  });

  @override
  State<TransitionsTileWidget> createState() => _TransitionsTileWidgetState();
}

class _TransitionsTileWidgetState extends State<TransitionsTileWidget> {
  @override
  void initState() {
    if (widget.items.first.dateCreate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) =>
          widget.cubit.addTilePosition(widget.items.first.dateCreate!, 0.0));
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.items.first.dateCreate != null) {
      widget.cubit.deleteTilePosition(widget.items.first.dateCreate!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding,
          vertical: AppConstants.horizontalScreenPadding),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Theme.of(context).canvasColor),
      child: Column(
        children: List.generate(
          widget.items.length,
          (int index) => _TransitionWidget(
            title: widget.items[index].note,
            amount: widget.items[index].amount,
            dateCreate: widget.items[index].dateCreate,
            avatar: widget.items[index].avatar,
            isDivider: widget.items[index] != widget.items.last,
          ),
        ),
      ),
    );
  }
}*/

class TransitionsTileWidget extends StatelessWidget {
  final List<PaymentInformation> items;
  const TransitionsTileWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding,
          vertical: AppConstants.horizontalScreenPadding),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Theme.of(context).canvasColor),
      child: Column(
        children: List.generate(
          items.length,
          (int index) => _TransitionWidget(
            title: items[index].note,
            amount: items[index].amount,
            dateCreate: items[index].dateCreate,
            avatar: items[index].avatar,
            isDivider: items[index] != items.last,
          ),
        ),
      ),
    );
  }
}

class _TransitionWidget extends StatelessWidget {
  final String? title;
  final String? avatar;
  final double? amount;
  final DateTime? dateCreate;
  final bool isDivider;

  const _TransitionWidget({
    Key? key,
    this.title,
    this.amount,
    this.dateCreate,
    this.avatar,
    this.isDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            UserAvatar(
                diameter: 48.0, withBorder: false, avatarUrl: avatar ?? ''),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title ?? '',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          amount != null ? amount.toString() : '',
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                  fontSize: 16.0, color: AppColors.online),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        dateCreate != null
                            ? DateFormat.jm().format(dateCreate!)
                            : '',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontSize: 15.0,
                              color: Theme.of(context).shadowColor,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (isDivider)
          const Divider(
            height: 16.0,
          ),
      ],
    );
  }
}
