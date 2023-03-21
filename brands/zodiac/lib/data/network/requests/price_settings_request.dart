import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'price_settings_request.g.dart';

@JsonSerializable(includeIfNull: false)
class PriceSettingsRequest extends AuthorizedRequest {
  @JsonKey(name: 'save_form')
  final int? saveForm;
  @JsonKey(name: 'have_call')
  final int? callEnabled;
  @JsonKey(name: 'call_fee')
  final double? callFee;
  @JsonKey(name: 'have_chat')
  final int? chatEnabled;
  @JsonKey(name: 'chat_fee')
  final double? chatFee;

  PriceSettingsRequest({
    this.saveForm,
    this.callEnabled,
    this.callFee,
    this.chatEnabled,
    this.chatFee,
  }) : super();

  factory PriceSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$PriceSettingsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PriceSettingsRequestToJson(this);
}
