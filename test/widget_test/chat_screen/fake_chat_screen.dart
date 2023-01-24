import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/chat_screen.dart';
import 'package:shared_advisor_interface/presentation/services/audio_player_service.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';
import 'package:shared_advisor_interface/presentation/services/sound/sound_record_service.dart';

import '../../common_variables.dart';

class FakeChatScreen extends StatelessWidget {
  const FakeChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainCubit mainCubit = context.read<MainCubit>();
    return BlocProvider(
      create: (_) => ChatCubit(
        testGetIt.get<ChatsRepository>(),
        testGetIt.get<ConnectivityService>(),
        mainCubit,
        testGetIt.get<SoundRecordService>(),
        testGetIt.get<AudioPlayerService>(),
        testGetIt.get<CheckPermissionService>(),
        () => showErrorAlert(context),
        () => confirmSendAnswerAlert(context),
        () => deleteAudioMessageAlert(context),
      ),
      child: const ChatContentWidget(),
    );
  }
}
