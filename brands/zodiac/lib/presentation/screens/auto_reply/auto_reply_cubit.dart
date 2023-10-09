import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
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
      _chatRepository.getAutoReplyList(AuthorizedRequest());
    } catch (e) {
      logger.d(e);
    }
  }
}
