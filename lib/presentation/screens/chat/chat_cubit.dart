import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/domain/repositories/sessions_repository.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SessionsRepository _repository;
  final String? questionId;

  ChatCubit(this._repository, this.questionId) : super(const ChatState());

  void startRecordingAudio() {
    emit(
      state.copyWith(
        isRecordingAudio: true,
      ),
    );
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
