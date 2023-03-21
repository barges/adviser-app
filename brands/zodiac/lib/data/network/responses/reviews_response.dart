import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/user_info/review_item_zodiac.dart';
import 'package:zodiac/data/network/responses/base_response.dart';

part 'reviews_response.g.dart';

@JsonSerializable(includeIfNull: false)
class ReviewsResponse extends BaseResponse {
  final int? count;
  final List<ZodiacReviewItem>? result;

  const ReviewsResponse({
    super.status,
    super.errorCode,
    super.errorMsg,
    super.message,
    this.count,
    this.result,
  });

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewsResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReviewsResponseToJson(this);
}
