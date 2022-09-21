import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/model/client_information.dart';

part 'ritual.g.dart';

@JsonSerializable()
class Ritual extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final int? totalQuestions;
  final int? leftQuestions;
  final String? identifier;
  final String? clientName;
  final String? sortDate;
  final String? lastQuestionId;
  final ClientInformation? clientInformation;
  final String? clientID;
  final String? type;
  final String? content;
  final List<dynamic>? attachments;
  final String? createdAt;
  final String? updatedAt;

  const Ritual({
    this.id,
    this.totalQuestions,
    this.leftQuestions,
    this.identifier,
    this.clientName,
    this.sortDate,
    this.lastQuestionId,
    this.clientInformation,
    this.clientID,
    this.type,
    this.content,
    this.attachments,
    this.createdAt,
    this.updatedAt,
  });

  factory Ritual.fromJson(Map<String, dynamic> json) => _$RitualFromJson(json);

  Map<String, dynamic> toJson() => _$RitualToJson(this);

  @override
  List<Object?> get props => [
        id,
        totalQuestions,
        leftQuestions,
        identifier,
        clientName,
        sortDate,
        lastQuestionId,
        clientInformation,
        clientID,
        type,
        content,
        attachments,
        createdAt,
        updatedAt
      ];
}
