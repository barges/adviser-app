import 'package:json_annotation/json_annotation.dart';

part 'image_sample_model.g.dart';

@JsonSerializable(includeIfNull: false, fieldRename: FieldRename.snake)
class ImageSampleModel {
  final String? imageAlias;
  final String? image;

  const ImageSampleModel({
    this.imageAlias,
    this.image,
  });

  factory ImageSampleModel.fromJson(Map<String, dynamic> json) =>
      _$ImageSampleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageSampleModelToJson(this);
}
