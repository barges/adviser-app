import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/list_request.dart';

part 'payments_list_request.g.dart';

@JsonSerializable()
class PaymentsListRequest extends ListRequest {
  final String sortby;
  final String sortdir;

  PaymentsListRequest(
      {this.sortby = "date_create",
      this.sortdir = "DESC",
      required super.count,
      required super.offset})
      : super();

  factory PaymentsListRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentsListRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PaymentsListRequestToJson(this);
}
