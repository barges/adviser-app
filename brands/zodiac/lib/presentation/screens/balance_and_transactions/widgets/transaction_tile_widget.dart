import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/data/models/enums/payment_source.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';
import 'package:zodiac/zodiac_extensions.dart';

const paddingTile = AppConstants.horizontalScreenPadding;
const paddingBottomTile = 8.0;
const userAvatarDiameter = 48.0;

class TransactionsTileWidget extends StatelessWidget {
  final List<PaymentInformation> items;
  const TransactionsTileWidget({super.key, required this.items});

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
          (int index) => _TransactionWidget(
            title: items[index].note,
            amount: items[index].amount,
            length: items[index].length,
            dateCreate: items[index].dateCreate,
            avatarUrl: items[index].avatar,
            paymentSource: items[index].source,
            isDivider: items[index] != items.last,
          ),
        ),
      ),
    );
  }
}

class _TransactionWidget extends StatelessWidget {
  final String? title;
  final String? avatarUrl;
  final double? amount;
  final Duration? length;
  final DateTime? dateCreate;
  final PaymentSource? paymentSource;
  final bool isDivider;

  const _TransactionWidget({
    Key? key,
    this.title,
    this.avatarUrl,
    this.amount,
    this.length,
    this.dateCreate,
    this.paymentSource,
    this.isDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAmountNegative = amount != null ? amount!.isNegative : false;
    String paymentLabel = paymentSource != null
        ? paymentSource!.toTranslationString(context)
        : '';
    if (length != null &&
            length!.inSeconds != 0 &&
            paymentSource == PaymentSource.call ||
        paymentSource == PaymentSource.chat ||
        paymentSource == PaymentSource.online ||
        paymentSource == PaymentSource.offline) {
      paymentLabel = ' $paymentLabel ${length!.formatDHMS(context)}';
    }
    return Column(
      children: [
        Row(
          children: [
            _Avatar(
              avatarUrl: avatarUrl,
              paymentSource: paymentSource,
              diameter: userAvatarDiameter,
              isMinusIcon: isAmountNegative,
            ),
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
                          style: theme.textTheme.labelLarge
                              ?.copyWith(fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          amount != null ? amount!.toCurrencyFormat('\$') : '',
                          textAlign: TextAlign.right,
                          style: theme.textTheme.labelLarge?.copyWith(
                              fontSize: 16.0,
                              color: isAmountNegative
                                  ? theme.errorColor
                                  : AppColors.online),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          paymentSource == null
                              ? ""
                              : isAmountNegative
                                  ? PaymentSource.withdrawal
                                      .toTranslationString(context)
                                  : paymentLabel,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 15.0,
                            color: theme.shadowColor,
                          ),
                        ),
                      ),
                      Text(
                        dateCreate != null
                            ? DateFormat.jm().format(dateCreate!.toLocal())
                            : '',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontSize: 15.0,
                          color: theme.shadowColor,
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
            height: paddingBottomTile * 2,
          ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? avatarUrl;
  final PaymentSource? paymentSource;
  final double diameter;
  final bool isMinusIcon;
  const _Avatar({
    required this.avatarUrl,
    required this.paymentSource,
    required this.diameter,
    this.isMinusIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvatarUrl = avatarUrl != null && avatarUrl!.isNotEmpty;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: diameter,
          width: diameter,
          decoration: BoxDecoration(
            color: isAvatarUrl && !isMinusIcon
                ? null
                : theme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
            image: isAvatarUrl && !isMinusIcon
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      avatarUrl!,
                      maxHeight: diameter.toInt() * 2,
                      maxWidth: diameter.toInt() * 2,
                    ),
                  )
                : null,
          ),
          child: isAvatarUrl && !isMinusIcon
              ? null
              : (isMinusIcon
                  ? Center(
                      child: Assets.vectors.minusInRect.svg(
                        width: 20.0,
                      ),
                    )
                  : Assets.vectors.placeholderProfileImage
                      .svg(color: theme.canvasColor)),
        ),
        if (paymentSource != null && paymentSource!.iconPath != null ||
            isMinusIcon)
          Positioned(
            left: 36.0,
            top: 24.0,
            child: isMinusIcon
                ? const _PaymentSourceIcon(PaymentSource.withdrawal)
                : _PaymentSourceIcon(paymentSource!),
          )
      ],
    );
  }
}

class _PaymentSourceIcon extends StatelessWidget {
  final PaymentSource paymentSource;
  const _PaymentSourceIcon(this.paymentSource);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.center,
      width: AppConstants.iconSize - 2,
      height: AppConstants.iconSize - 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.primaryColor,
        border: Border.all(
          width: 2.0,
          color: theme.canvasColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: SvgPicture.asset(paymentSource.iconPath!),
    );
  }
}
