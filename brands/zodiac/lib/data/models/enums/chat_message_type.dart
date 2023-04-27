enum ChatMessageType {
  simple,
  coupon,
  review,
  products,
  system,
  private,
  tips,
  image,
  startChat,
  endChat,
  startCall,
  endCall,
  advisorMessages,
  extend,
  missed,
  couponAfterSession,
  translated,
  productList,
  audio,
  ;

  static ChatMessageType typeFromInt(int? i) {
    switch (i) {
      case 3:
        return ChatMessageType.simple;
      case 4:
        return ChatMessageType.coupon;
      case 5:
        return ChatMessageType.review;
      case 6:
        return ChatMessageType.products;
      case 7:
        return ChatMessageType.system;
      case 8:
        return ChatMessageType.private;
      case 9:
        return ChatMessageType.tips;
      case 10:
        return ChatMessageType.image;
      case 11:
        return ChatMessageType.startChat;
      case 12:
        return ChatMessageType.endChat;
      case 13:
        return ChatMessageType.startCall;
      case 14:
        return ChatMessageType.endCall;
      case 15:
        return ChatMessageType.advisorMessages;
      case 16:
        return ChatMessageType.extend;
      case 17:
        return ChatMessageType.missed;
      case 18:
        return ChatMessageType.couponAfterSession;
      case 19:
        return ChatMessageType.translated;
      case 20:
        return ChatMessageType.productList;
      case 21:
        return ChatMessageType.audio;
      default:
        return ChatMessageType.simple;
    }
  }

  int get intFromType {
    switch (this) {
      case ChatMessageType.simple:
        return 3;
      case ChatMessageType.coupon:
        return 4;
      case ChatMessageType.review:
        return 5;
      case ChatMessageType.products:
        return 6;
      case ChatMessageType.system:
        return 7;
      case ChatMessageType.private:
        return 8;
      case ChatMessageType.tips:
        return 9;
      case ChatMessageType.image:
        return 10;
      case ChatMessageType.startChat:
        return 11;
      case ChatMessageType.endChat:
        return 12;
      case ChatMessageType.startCall:
        return 13;
      case ChatMessageType.endCall:
        return 14;
      case ChatMessageType.advisorMessages:
        return 15;
      case ChatMessageType.extend:
        return 16;
      case ChatMessageType.missed:
        return 17;
      case ChatMessageType.couponAfterSession:
        return 18;
      case ChatMessageType.translated:
        return 19;
      case ChatMessageType.productList:
        return 20;
      case ChatMessageType.audio:
        return 21;
    }
  }
}
