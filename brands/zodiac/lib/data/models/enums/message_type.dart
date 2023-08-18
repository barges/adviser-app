import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

enum MessageType {
  undefined,
  chat,
  call,
  private;

  static MessageType fromJson(int? value) {
    switch (value) {
      case 0:
        return MessageType.undefined;
      case 1:
        return MessageType.chat;
      case 2:
        return MessageType.call;
      case 3:
        return MessageType.private;
      default:
        return MessageType.undefined;
    }
  }

  String? get iconPath {
    switch (this) {
      case chat:
        return Assets.zodiac.vectors.chatFee.path;
      case call:
        return Assets.zodiac.vectors.call.path;
      default:
        return null;
    }
  }
}
