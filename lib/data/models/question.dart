
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/client_information.dart';
part 'question.g.dart';

@JsonSerializable()
class Question extends Equatable{
  final ClientInformation? clientInformation;
  @JsonKey(name: '_id')
  final String? id;
  final String? clientID;
  final String? type;
  final String? content;
  final List<dynamic>? attachments;
  final String? clientName;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const Question({
      this.clientInformation,
      this.id, 
      this.clientID, 
      this.type, 
      this.content, 
      this.attachments, 
      this.clientName, 
      this.status, 
      this.createdAt, 
      this.updatedAt});

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  List<Object?> get props => [clientInformation,
    id,
    clientID,
    type,
    content,
    attachments,
    clientName,
    status,
    createdAt,
    updatedAt];





}