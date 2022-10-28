import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/network/responses/customer_info_response/questions_subscription.dart';

part 'customer_info_response.g.dart';
part 'customer_info_response.freezed.dart';

@freezed
class CustomerInfoResponse with _$CustomerInfoResponse  {
  @JsonSerializable(includeIfNull: false)
  factory CustomerInfoResponse({
    QuestionsSubscription? questionsSubscription,
  @JsonKey(name: '_id')
   String? lId,
   String? country,
   String? birthdate,
   String? firstName,
   String? gender,
   String? lastName,
   String? zodiac,
   bool? isProfileCompleted,
   String? id,
   String? countryFullName,
   int? totalMessages,
   Map<String,String>? advisorMatch,
  }) = _CustomerInfoResponse;

  factory CustomerInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoResponseFromJson(json);

}
