import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_advisor_interface/data/network/responses/customer_info_response/questions_subscription.dart';

import 'package:json_annotation/json_annotation.dart';

part 'customer_info_response.g.dart';

@JsonSerializable(includeIfNull: false)
class CustomerInfoResponse extends Equatable {
  const CustomerInfoResponse({
    this.questionsSubscription,
    this.lId,
    this.country,
    this.birthdate,
    this.firstName,
    this.gender,
    this.lastName,
    this.zodiac,
    this.isProfileCompleted,
    this.id,
    this.countryFullName,
    this.totalMessages,
    this.advisorMatch,
  });

  final QuestionsSubscription? questionsSubscription;
  @JsonKey(name: '_id')
  final String? lId;
  final String? country;
  final String? birthdate;
  final String? firstName;
  final String? gender;
  final String? lastName;
  final String? zodiac;
  final bool? isProfileCompleted;
  final String? id;
  final String? countryFullName;
  final int? totalMessages;
  final Map<String,String>? advisorMatch;

  factory CustomerInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerInfoResponseToJson(this);

  @override
  List<Object?> get props => [
        questionsSubscription,
        lId,
        country,
        birthdate,
        firstName,
        gender,
        lastName,
        zodiac,
        isProfileCompleted,
        id,
        countryFullName,
        totalMessages,
        advisorMatch,
      ];
}
