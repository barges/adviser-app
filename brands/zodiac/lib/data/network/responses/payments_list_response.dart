import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/payment/payment_information.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'payments_list_response.g.dart';

@JsonSerializable(includeIfNull: false)
class PaymentsListResponse extends BaseResponse {
  @JsonKey(fromJson: _toInt)
  final int? count;
  final List<PaymentInformation>? result;

  const PaymentsListResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory PaymentsListResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentsListResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PaymentsListResponseToJson(this);
}

int? _toInt(String? value) => value != null ? int.tryParse(value) : null;
