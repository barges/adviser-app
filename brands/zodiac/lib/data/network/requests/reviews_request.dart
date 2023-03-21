import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'reviews_request.g.dart';

@JsonSerializable()
class ReviewsRequest extends AuthorizedRequest {
  @JsonKey(name: 'expert_id')
  final String expertId;
  final int count;
  final int offset;

  ReviewsRequest(
      {required this.expertId, required this.count, required this.offset})
      : super();

  factory ReviewsRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewsRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReviewsRequestToJson(this);
}
