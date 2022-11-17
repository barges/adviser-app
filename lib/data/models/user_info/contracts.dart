import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/models/user_info/contract.dart';

part 'contracts.freezed.dart';

part 'contracts.g.dart';

@freezed
class Contracts with _$Contracts {
  @JsonSerializable(includeIfNull: false)
  const factory Contracts({
    List<Contract>? updates,

  }) = _Contracts;

  factory Contracts.fromJson(Map<String, dynamic> json) =>
      _$ContractsFromJson(json);
}