import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:vibration/vibration.dart';
import 'package:zodiac/data/network/requests/authorized_request.dart';
import 'package:zodiac/data/network/responses/advice_tips_response.dart';
import 'package:zodiac/domain/repositories/zodiac_chats_repository.dart';
import 'package:zodiac/presentation/screens/starting_chat/starting_chat_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac.dart';

const List<int> vibrationPattern = [0, 200, 100, 300, 400];

class StartingChatCubit extends Cubit<StartingChatState> {
  final WebSocketManager _webSocketManager;
  final ZodiacChatsRepository _zodiacChatsRepository;

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  StreamSubscription? _endChatSubscription;

  StartingChatCubit(this._webSocketManager, this._zodiacChatsRepository)
      : super(const StartingChatState()) {
    _getAdviceTips();
    Vibration.vibrate(pattern: vibrationPattern);
    _assetsAudioPlayer.open(
      Audio(Assets.audios.chatIncoming),
      loopMode: LoopMode.single,
    );

    _endChatSubscription = _webSocketManager.endChatTrigger.listen((value) {
      ZodiacBrand().context?.pop();
    });
  }

  @override
  Future<void> close() async {
    _endChatSubscription?.cancel();
    Vibration.cancel();
    _assetsAudioPlayer.dispose();
    super.close();
  }

  Future<void> _getAdviceTips() async {
    final AdviceTipsResponse adviceTipsResponse =
        await _zodiacChatsRepository.getAdviceTips(AuthorizedRequest());
    logger.d(adviceTipsResponse);
    if (adviceTipsResponse.result == true &&
        adviceTipsResponse.result != null) {
      emit(state.copyWith(adviceTip: adviceTipsResponse.result![0]));
    }
  }

  void declineCall(int? opponentId) {
    _webSocketManager.sendDeclineCall(opponentId: opponentId);
  }
}
