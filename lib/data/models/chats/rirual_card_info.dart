import 'package:freezed_annotation/freezed_annotation.dart';

part 'rirual_card_info.freezed.dart';

@freezed
class RitualCardInfo with _$RitualCardInfo {
  const factory RitualCardInfo({
    final String? name,
    final DateTime? birthdate,
    final String? gender,
    final String? leftImageTitle,
    final String? rightImageTitle,
    final String? leftImage,
    final String? rightImage,
  }) = _RitualCardInfo;
}
