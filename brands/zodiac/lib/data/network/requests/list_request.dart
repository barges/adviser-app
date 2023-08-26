import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'list_request.g.dart';

@JsonSerializable(
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
class ListRequest extends AuthorizedRequest {
  final int? count;
  final int? offset;
  final String? search;

  ListRequest({required this.count, required this.offset, this.search})
      : super();

  factory ListRequest.fromJson(Map<String, dynamic> json) =>
      _$ListRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ListRequestToJson(this);
}
