import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_unit.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ReportsUnitWidget extends StatelessWidget {
  final ReportsUnit reportsUnit;
  final String currencySymbol;
  final double rate;
  final bool previousIsCanceled;
  final bool isLastElement;

  const ReportsUnitWidget({
    Key? key,
    required this.reportsUnit,
    required this.currencySymbol,
    required this.rate,
    required this.previousIsCanceled,
    required this.isLastElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isCanceled = reportsUnit.amountCancelled != null &&
        reportsUnit.numberCancelled != null;
    return isCanceled
        ? Padding(
            padding: EdgeInsets.only(top: previousIsCanceled ? 0.0 : 24.0),
            child: Column(
              children: [
                if (!previousIsCanceled)
                  const Divider(
                    height: 1.0,
                  ),
                const SizedBox(
                  height: 16.0,
                ),
                _ReportsUnitCanceled(
                  reportsUnit: reportsUnit,
                  currencySymbol: currencySymbol,
                  rate: rate,
                ),
                const SizedBox(
                  height: 16.0,
                ),
                if (!isLastElement)
                  const Divider(
                    height: 1.0,
                  ),
              ],
            ),
          )
        : Padding(
            padding:
                EdgeInsets.only(top: 24.0, bottom: isLastElement ? 24.0 : 0.0),
            child: _ReportsUnit(
              reportsUnit: reportsUnit,
              currencySymbol: currencySymbol,
              rate: rate,
            ),
          );
  }
}

class _ReportsUnit extends StatelessWidget {
  final ReportsUnit reportsUnit;
  final String currencySymbol;
  final double rate;
  final bool isCanceled;

  const _ReportsUnit({
    Key? key,
    required this.reportsUnit,
    required this.currencySymbol,
    required this.rate,
    this.isCanceled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.iconButtonSize,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: AppConstants.iconButtonSize,
            width: AppConstants.iconButtonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCanceled ? Get.theme.errorColor : Get.theme.primaryColor,
            ),
            child: SvgPicture.asset(
              isCanceled
                  ? Assets.vectors.close.path
                  : reportsUnit.type?.iconPath ?? '',
              color: Get.theme.backgroundColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Text(
                    '${reportsUnit.type?.sessionName} '
                    '(${isCanceled ? reportsUnit.numberCancelled : reportsUnit.number})',
                    style: Get.textTheme.bodySmall?.copyWith(
                      fontSize: 14.0,
                    ),
                  ),
                  if (!isCanceled)
                    Row(
                      children: [
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          '($currencySymbol ${rate.toStringAsFixed(2)})',
                          style: Get.textTheme.bodySmall?.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Get.theme.shadowColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 18.0,
                child: Text(
                  '${isCanceled ? '' : '~ '}$currencySymbol '
                  '${isCanceled ? reportsUnit.amountCancelled?.toStringAsFixed(2) : reportsUnit.amount?.toStringAsFixed(2)}',
                  style: Get.textTheme.bodySmall?.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: isCanceled
                        ? Get.theme.errorColor
                        : Get.textTheme.bodySmall?.color,
                  ),
                ),
              ),
              if (isCanceled)
                SizedBox(
                  height: 14.0,
                  child: Text(
                    S.of(context).earned,
                    style: Get.textTheme.bodySmall?.copyWith(
                      fontSize: 12.0,
                      color: Get.theme.shadowColor,
                    ),
                  ),
                )
            ],
          )
        ],
      ),
    );
  }
}

class _ReportsUnitCanceled extends StatelessWidget {
  final ReportsUnit reportsUnit;
  final String currencySymbol;
  final double rate;

  const _ReportsUnitCanceled({
    Key? key,
    required this.reportsUnit,
    required this.currencySymbol,
    required this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ReportsUnit(
          reportsUnit: reportsUnit,
          currencySymbol: currencySymbol,
          rate: rate,
        ),
        const SizedBox(
          height: 12.0,
        ),
        _ReportsUnit(
          reportsUnit: reportsUnit,
          currencySymbol: currencySymbol,
          rate: rate,
          isCanceled: true,
        ),
      ],
    );
  }
}
