import 'package:flutter/widgets.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

enum PaymentSource {
  none,
  topUp,
  chat,
  call,
  bonus,
  return_,
  tips,
  service,
  union,
  withdrawal,
  online,
  offline;

  static PaymentSource fromInt(int? i) {
    for (var item in PaymentSource.values) {
      if (item.index == i) {
        return item;
      }
    }
    return PaymentSource.none;
  }

  String? get iconPath {
    switch (this) {
      case PaymentSource.topUp:
        return Assets.vectors.paymentTopUp.path;
      case PaymentSource.chat:
        return Assets.vectors.paymentChat.path;
      case PaymentSource.call:
        return Assets.vectors.paymentCall.path;
      case PaymentSource.bonus:
        return Assets.vectors.paymentBonus.path;
      case PaymentSource.return_:
        return Assets.vectors.paymentReturn.path;
      case PaymentSource.tips:
        return Assets.vectors.paymentTips.path;
      case PaymentSource.service:
        return Assets.vectors.paymentService.path;
      case PaymentSource.withdrawal:
        return Assets.vectors.paymentWithdrawal.path;
      case PaymentSource.online:
        return Assets.vectors.paymentOnlineServices.path;
      case PaymentSource.offline:
        return Assets.vectors.paymentOfflineService.path;
      case PaymentSource.union:
      case PaymentSource.none:
        return null;
    }
  }

  String toTranslationString(BuildContext context) {
    switch (this) {
      case PaymentSource.topUp:
        return SZodiac.of(context).topUpZodiac;
      case PaymentSource.chat:
        return SZodiac.of(context).chatZodiac;
      case PaymentSource.call:
        return SZodiac.of(context).callZodiac;
      case PaymentSource.bonus:
        return SZodiac.of(context).bonusZodiac;
      case PaymentSource.return_:
        return SZodiac.of(context).returnZodiac;
      case PaymentSource.tips:
        return SZodiac.of(context).tipZodiac;
      case PaymentSource.service:
        return SZodiac.of(context).serviceZodiac;
      case PaymentSource.withdrawal:
        return SZodiac.of(context).withdrawalZodiac;
      case PaymentSource.online:
        return SZodiac.of(context).onlineServicesZodiac;
      case PaymentSource.offline:
        return SZodiac.of(context).offlineServiceZodiac;
      case PaymentSource.union:
      case PaymentSource.none:
        return '';
    }
  }
}
