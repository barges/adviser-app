import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/models/chat/private_message_model.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/auto_reply_list_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chat_repository.dart';
import 'package:zodiac/presentation/screens/auto_reply/auto_reply_state.dart';

@injectable
class AutoReplyCubit extends Cubit<AutoReplyState> {
  final ZodiacChatRepository _chatRepository;

  AutoReplyCubit(
    this._chatRepository,
  ) : super(const AutoReplyState()) {
    _getInitialData();
  }

  Future<void> _getInitialData() async {
    try {
      final AutoReplyListResponse response =
          await _chatRepository.getAutoReplyList(AuthorizedRequest());

      if (response.status == true) {
        emit(state.copyWith(messages: response.result));
      }
    } catch (e) {
      logger.d(e);
    }
  }

  void selectMessage(int? id) {
    emit(state.copyWith(selectedMessageId: id));
  }

  void setSingleTime(String time) {
    List<PrivateMessageModel>? messages = List.of(state.messages ?? []);

    PrivateMessageModel? privateMessage = messages.firstWhereOrNull(
        (element) => element.message?.contains(state.time) == true);
    if (privateMessage != null) {
      int? messageIndex = messages.indexOf(privateMessage);

      String message =
          privateMessage.message?.replaceFirst(state.time, time) ?? '';

      messages[messageIndex] = privateMessage.copyWith(message: message);

      emit(state.copyWith(messages: messages, time: time));
    }
  }
}
