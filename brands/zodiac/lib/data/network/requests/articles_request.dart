import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'articles_request.g.dart';

@JsonSerializable()
class ArticlesRequest extends AuthorizedRequest {
  final int? count;
  final int? offset;

  ArticlesRequest({required this.count, required this.offset}) : super();

  factory ArticlesRequest.fromJson(Map<String, dynamic> json) =>
      _$ArticlesRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticlesRequestToJson(this);
}
