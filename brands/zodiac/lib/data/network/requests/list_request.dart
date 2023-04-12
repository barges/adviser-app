import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'list_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class ListRequest extends AuthorizedRequest {
  int count;
  int offset;

  ListRequest({required this.count, required this.offset}) : super();

  factory ListRequest.fromJson(Map<String, dynamic> json) =>
      _$ListRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListRequestToJson(this);
}