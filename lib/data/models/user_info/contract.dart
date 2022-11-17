import 'package:freezed_annotation/freezed_annotation.dart';

part 'contract.freezed.dart';

part 'contract.g.dart';

@freezed
class Contract with _$Contract {
  @JsonSerializable(includeIfNull: false)
  const factory Contract({
    @JsonKey(name: '_id')
    String? id,

  }) = _Contract;

  factory Contract.fromJson(Map<String, dynamic> json) =>
      _$ContractFromJson(json);
}