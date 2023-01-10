import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_screen.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

class FakeChatScreen extends StatelessWidget {
  final ChatsRepository chatsRepository;
  final ConnectivityService connectivityService;

  const FakeChatScreen({
    Key? key,
    required this.chatsRepository,
    required this.connectivityService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainCubit mainCubit = context.read<MainCubit>();
    ChatCubit chatCubit = ChatCubit(
      chatsRepository,
      connectivityService,
      mainCubit,
      () => showErrorAlert(context),
      () => confirmSendAnswerAlert(context),
    );
    chatCubit.emit(
        chatCubit.state.copyWith(flutterSoundPlayer: FlutterSoundPlayer()));
    chatCubit.playerMedia = chatCubit.state.flutterSoundPlayer;
    return BlocProvider(
      create: (_) => chatCubit,
      child: ChatContentWidget(
        chatsRepository: chatsRepository,
        connectivityService: connectivityService,
      ),
    );
  }
}
