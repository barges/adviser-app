import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'list_request.g.dart';

@JsonSerializable(includeIfNull: false)
class ListRequest extends AuthorizedRequest {
  final int count;
  final int offset;

  ListRequest({required this.count, required this.offset}) : super();

  factory ListRequest.fromJson(Map<String, dynamic> json) =>
      _$ListRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListRequestToJson(this);
}
