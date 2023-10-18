import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/gender.dart';

part 'rirual_card_info.freezed.dart';

@freezed
class RitualCardInfo with _$RitualCardInfo {
  const factory RitualCardInfo({
    final String? name,
    final DateTime? birthdate,
    final Gender? gender,
    final String? leftImageTitle,
    final String? rightImageTitle,
    final String? leftImage,
    final String? rightImage,
  }) = _RitualCardInfo;
}
