import 'package:json_annotation/json_annotation.dart';

part 'questions_subscription.g.dart';

@JsonSerializable(includeIfNull: false)
class QuestionsSubscription{
  final int? status;
  final bool? active;

  const QuestionsSubscription({
    this.status,
    this.active,
  });

  factory QuestionsSubscription.fromJson(Map<String, dynamic> json) =>
      _$QuestionsSubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsSubscriptionToJson(this);
}
