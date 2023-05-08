import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audible_mode/audible_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:vibration/vibration.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/presentation/screens/starting_chat/starting_chat_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac.dart';

class StartingChatCubit extends Cubit<StartingChatState> {
  final WebSocketManager _webSocketManager;
  final BrandManager _brandManager;
  final MainCubit _mainCubit;

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  StreamSubscription? _endChatSubscription;
  StreamSubscription? _appLifecycleSubscription;
  StreamSubscription? _soundModeSubscription;

  bool shouldVibrate = true;

  StartingChatCubit(this._webSocketManager, this._brandManager, this._mainCubit,
      BuildContext context)
      : super(const StartingChatState()) {
    _startVibration();

    _startMelody();

    _endChatSubscription = _webSocketManager.endChatTrigger.listen((value) {
      context.popForced();
    });

    _appLifecycleSubscription =
        _mainCubit.changeAppLifecycleStream.listen((value) {
      shouldVibrate = false;
      context.popForced();
    });

    _soundModeSubscription = Audible.audibleStream.listen((event) async {
      if (event == AudibleProfile.SILENT_MODE) {
        _assetsAudioPlayer.setVolume(0.0);
      } else {
        final double currentVolume = await Audible.getCurrentVolume;
        _assetsAudioPlayer.setVolume(currentVolume);
      }
    });
  }

  @override
  Future<void> close() async {
    _endChatSubscription?.cancel();
    _assetsAudioPlayer.dispose();
    _appLifecycleSubscription?.cancel();
    _soundModeSubscription?.cancel();
    Vibration.cancel();
    super.close();
  }

  Future<void> _startVibration() async {
    if (await Vibration.hasVibrator() == true) {
      while (shouldVibrate && !isClosed) {
        await Vibration.vibrate();
        await Future.delayed(const Duration(milliseconds: 1500));
      }
    }
  }

  Future<void> _startMelody() async {
    final AudibleProfile? soundMode = await Audible.getAudibleProfile;
    final double currentVolume = await Audible.getCurrentVolume;

    _assetsAudioPlayer.open(
      Audio(Assets.audios.chatIncoming),
      loopMode: LoopMode.single,
      respectSilentMode: true,
      volume: soundMode == AudibleProfile.SILENT_MODE ? 0.0 : currentVolume,
    );
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
