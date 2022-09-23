import 'package:equatable/equatable.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/ritual.dart';

part 'rituals_response.g.dart';

@JsonSerializable()
class RitualsResponse extends Equatable {
  final List<Ritual>? rituals;
  final bool? hasMore;
  final String? limit;

  const RitualsResponse({
    this.rituals,
    this.hasMore,
    this.limit,
  });

  factory RitualsResponse.fromJson(Map<String, dynamic> json) =>
      _$RitualsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RitualsResponseToJson(this);

  @override
  List<Object?> get props => [rituals, hasMore, limit];
}
