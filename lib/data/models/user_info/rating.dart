import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable(includeIfNull: false)
class Rating extends Equatable {
  final int? de;
  final int? en;
  final int? es;
  final int? pt;

  const Rating({
    this.de,
    this.en,
    this.es,
    this.pt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) =>
      _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);

  @override
  List<Object?> get props => [de, en, es, pt];
}