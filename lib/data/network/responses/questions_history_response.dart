/*import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/question.dart';

part 'questions_history_response.dart.g.dart';

@JsonSerializable()
class QuestionsListResponse extends Equatable {
  final List<Question>? questions;
  final bool? hasMore;
  final int? limit;
  final String? lastId;

  const QuestionsListResponse(
      {this.questions, this.hasMore, this.limit, this.lastId});

  factory QuestionsListResponse.fromJson(Map<String, dynamic> json) =>
      _$QuestionsListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionsListResponseToJson(this);

  @override
  List<Object?> get props => [questions, hasMore, limit, lastId];
}*/
