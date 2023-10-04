import 'package:json_annotation/json_annotation.dart';
import 'package:zodiac/data/models/edit_profile/saved_brand_locales_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';

part 'save_brand_locales_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SaveBrandLocalesRequest extends AuthorizedRequest {
  List<SavedBrandLocalesModel> brandLocales;

  SaveBrandLocalesRequest({
    required this.brandLocales,
  }) : super();

  factory SaveBrandLocalesRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveBrandLocalesRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SaveBrandLocalesRequestToJson(this);
}
