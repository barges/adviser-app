import 'package:json_annotation/json_annotation.dart';

enum ChatItemStatusType {
  @JsonValue("TAKEN")
  taken,
  @JsonValue("OPEN")
  open,
  @JsonValue("ANSWERED")
  answered,
  @JsonValue("CANCELLED_BY_ADMIN")
  cancelledByAdmin,
}
