import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zodiac/data/models/chat/chat_message_model.dart';

part 'chat_message_ui_model.freezed.dart';

@freezed
class ChatMessageUiModel with _$ChatMessageUiModel {
  const factory ChatMessageUiModel.simple(ChatMessageModel message) = Simple;

  const factory ChatMessageUiModel.coupon(ChatMessageModel message) = Coupon;

  const factory ChatMessageUiModel.review(ChatMessageModel message) = Review;

  const factory ChatMessageUiModel.products(ChatMessageModel message) =
      Products;

  const factory ChatMessageUiModel.system(ChatMessageModel message) = System;

  const factory ChatMessageUiModel.private(ChatMessageModel message) = Private;

  const factory ChatMessageUiModel.tips(ChatMessageModel message) = Tips;

  const factory ChatMessageUiModel.image(ChatMessageModel message) = Image;

  const factory ChatMessageUiModel.startChat(ChatMessageModel message) =
      StartChat;

  const factory ChatMessageUiModel.endChat(ChatMessageModel message) = EndChat;

  const factory ChatMessageUiModel.startCall(ChatMessageModel message) =
      StartCall;

  const factory ChatMessageUiModel.endCall(ChatMessageModel message) = EndCall;

  const factory ChatMessageUiModel.advisorMessages(ChatMessageModel message) =
      AdvisorMessages;

  const factory ChatMessageUiModel.extend(ChatMessageModel message) = Extend;

  const factory ChatMessageUiModel.missed(ChatMessageModel message) = Missed;

  const factory ChatMessageUiModel.couponAfterSession(
      ChatMessageModel message) = CouponAfterSession;

  const factory ChatMessageUiModel.translated(ChatMessageModel message) =
      Translated;

  const factory ChatMessageUiModel.productList(ChatMessageModel message) =
      ProductList;

  const factory ChatMessageUiModel.audio(ChatMessageModel message) = Audio;
}
