import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_screen.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/sound/sound_record_service.dart';

class FakeChatScreen extends StatelessWidget {
  final ChatsRepository chatsRepository;
  final ConnectivityService connectivityService;
  final SoundRecordService soundRecordService;

  const FakeChatScreen({
    Key? key,
    required this.chatsRepository,
    required this.connectivityService,
    required this.soundRecordService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainCubit mainCubit = context.read<MainCubit>();
    return BlocProvider(
      create: (_) => ChatCubit(
        chatsRepository,
        connectivityService,
        mainCubit,
        soundRecordService,
        () => showErrorAlert(context),
        () => confirmSendAnswerAlert(context),
      ),
      child: ChatContentWidget(
        chatsRepository: chatsRepository,
        connectivityService: connectivityService,
      ),
    );
  }
}
