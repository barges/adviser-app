import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:vibration/vibration.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/presentation/screens/starting_chat/starting_chat_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac.dart';

const List<int> vibrationPattern = [0, 200, 100, 300, 400];

class StartingChatCubit extends Cubit<StartingChatState> {
  final WebSocketManager _webSocketManager;
  final BrandManager _brandManager;
  final MainCubit _mainCubit;

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  StreamSubscription? _endChatSubscription;
  StreamSubscription? _appLifecycleSubscription;

  StartingChatCubit(this._webSocketManager, this._brandManager, this._mainCubit,
      BuildContext context)
      : super(const StartingChatState()) {
    Vibration.vibrate(pattern: vibrationPattern);
    _assetsAudioPlayer.open(
      Audio(Assets.audios.chatIncoming),
      loopMode: LoopMode.single,
      respectSilentMode: true,
    );

    _endChatSubscription = _webSocketManager.endChatTrigger.listen((value) {
      context.popForced();
    });

    _appLifecycleSubscription =
        _mainCubit.changeAppLifecycleStream.listen((value) {
      if (value) {
        _assetsAudioPlayer.play();
      } else {
        _assetsAudioPlayer.pause();
      }
    });
  }

  @override
  Future<void> close() async {
    _endChatSubscription?.cancel();
    Vibration.cancel();
    _assetsAudioPlayer.dispose();
    _appLifecycleSubscription?.cancel();
    super.close();
  }

  void declineChat(int? opponentId) {
    _webSocketManager.sendDeclineCall(opponentId: opponentId);
  }

  void startChat(BuildContext context, UserData userData) {
    if (_brandManager.getCurrentBrand() is! ZodiacBrand) {
      _brandManager.setCurrentBrand(ZodiacBrand());
    }
    ZodiacBrand().context?.push(
            route: ZodiacChat(
          userData: userData,
          fromStartingChat: true,
        ));
    context.popForced(true);
  }
}
