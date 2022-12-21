import 'package:json_annotation/json_annotation.dart';
import 'package:shared_advisor_interface/data/models/chats/rirual_card_info.dart';
import 'package:shared_advisor_interface/data/models/chats/story.dart';
import 'package:shared_advisor_interface/data/models/enums/gender.dart';
import 'package:shared_advisor_interface/data/models/enums/ritual_info_card_field_data.dart';
import 'package:shared_advisor_interface/data/models/enums/ritual_info_card_field_type.dart';

part 'rituals_response.g.dart';

@JsonSerializable()
class RitualsResponse {
  final Story? story;
  final String? clientID;
  final String? clientName;
  final List<dynamic>? inputFieldsData;
  @JsonKey(ignore: true)
  late final RitualCardInfo? ritualCardInfo;

  RitualsResponse({
    this.story,
    this.clientID,
    this.clientName,
    this.inputFieldsData,
  }) {
    String? firstName;
    String? lastName;
    DateTime? birthdate;
    String? gender;
    String? leftImageTitle;
    String? rightImageTitle;
    String? leftImage;
    String? rightImage;

    if (inputFieldsData != null && inputFieldsData!.isNotEmpty) {
      bool isLeft = true;
      for (Map<String, dynamic> dataItem in inputFieldsData!) {
        dynamic inputField = dataItem[RitualInfoCardFieldData.inputField.name];
        dynamic placeholderText =
            inputField[RitualInfoCardFieldData.placeholderText.name];
        dynamic value = dataItem[RitualInfoCardFieldData.value.name];

        if (inputField != null) {
          dynamic subType = inputField[RitualInfoCardFieldData.subType.name];
          dynamic type = inputField[RitualInfoCardFieldData.type.name];

          if (subType == RitualInfoCardFieldType.firstName.name) {
            firstName = value;
          } else if (subType == RitualInfoCardFieldType.lastName.name) {
            lastName = value;
          } else if (subType == RitualInfoCardFieldType.birthdate.name) {
            birthdate = value != null ? DateTime.parse(value) : null;
          } else if (subType == RitualInfoCardFieldType.gender.name) {
            gender = value;
          } else if (type == RitualInfoCardFieldType.image.name && isLeft) {
            leftImageTitle = placeholderText;
            leftImage = value;
            isLeft = false;
          } else if (type == RitualInfoCardFieldType.image.name && !isLeft) {
            rightImageTitle = placeholderText;
            rightImage = value;
          }
        }
      }
    }

    ritualCardInfo = RitualCardInfo(
      name: '${firstName ?? ''} ${lastName ?? ''}',
      birthdate: birthdate,
      gender: Gender.genderFromString(gender),
      leftImageTitle: leftImageTitle,
      leftImage: leftImage,
      rightImageTitle: rightImageTitle,
      rightImage: rightImage,
    );
  }

  factory RitualsResponse.fromJson(Map<String, dynamic> json) =>
      _$RitualsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RitualsResponseToJson(this);
}
