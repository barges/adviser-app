import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audible_mode/audible_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/analytics/analytics_event.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/services/sound_mode_service.dart';
import 'package:vibration/vibration.dart';
import 'package:zodiac/data/models/chat/call_data.dart';
import 'package:zodiac/data/models/chat/user_data.dart';
import 'package:zodiac/infrastructure/routing/route_paths.dart';
import 'package:zodiac/presentation/screens/starting_chat/starting_chat_state.dart';
import 'package:zodiac/services/websocket_manager/websocket_manager.dart';
import 'package:zodiac/zodiac.dart';

class StartingChatCubit extends Cubit<StartingChatState> {
  final WebSocketManager _webSocketManager;
  final BrandManager _brandManager;
  final MainCubit _mainCubit;
  final SoundModeService _soundModeService;
  final CallData _startCallData;

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  StreamSubscription? _endChatSubscription;
  StreamSubscription? _appLifecycleSubscription;
  StreamSubscription? _silentModeSubscription;

  bool screenOpened = true;
  bool? shouldVibrate;

  StartingChatCubit(
    this._webSocketManager,
    this._brandManager,
    this._mainCubit,
    this._soundModeService,
    this._startCallData,
    BuildContext context,
  ) : super(const StartingChatState()) {
    _startVibration();

    _startMelody();

    _endChatSubscription = _webSocketManager.endChatTrigger.listen((value) {
      context.popForced();
    });

    _appLifecycleSubscription =
        _mainCubit.changeAppLifecycleStream.listen((value) {
      if (screenOpened) {
        context.popForced();
        _assetsAudioPlayer.setVolume(0.0);
        screenOpened = false;
      }
    });

    _silentModeSubscription =
        _soundModeService.soundModeStream.listen((soundMode) async {
      if (soundMode == DeviceSoundMode.normal) {
        final double currentVolume = await Audible.getCurrentVolume;
        _assetsAudioPlayer.setVolume(currentVolume);
        shouldVibrate = true;
      } else if (soundMode == DeviceSoundMode.vibrate) {
        _assetsAudioPlayer.setVolume(0.0);
        shouldVibrate = true;
      } else {
        _assetsAudioPlayer.setVolume(0.0);
        shouldVibrate = false;
      }
    });
  }

  @override
  Future<void> close() async {
    _endChatSubscription?.cancel();
    _assetsAudioPlayer.dispose();
    _appLifecycleSubscription?.cancel();
    _silentModeSubscription?.cancel();
    Vibration.cancel();
    super.close();
  }

  Future<void> _startVibration() async {
    final DeviceSoundMode soundMode = await _soundModeService.soundMode;
    shouldVibrate = soundMode != DeviceSoundMode.silent;

    if (await Vibration.hasVibrator() == true) {
      while (shouldVibrate == true && screenOpened && !isClosed) {
        await Vibration.vibrate();
        await Future.delayed(const Duration(milliseconds: 1500));
      }
    }
  }

  Future<void> _startMelody() async {
    final DeviceSoundMode soundMode = await _soundModeService.soundMode;
    logger.d(soundMode);

    final double currentVolume = await Audible.getCurrentVolume;

    _assetsAudioPlayer.open(
      Audio(Assets.zodiac.audios.chatIncoming),
      loopMode: LoopMode.single,
      respectSilentMode: true,
      volume: soundMode == DeviceSoundMode.normal ? currentVolume : 0.0,
    );
  }

  void declineChat(int? opponentId) {
    _webSocketManager.sendDeclineCall(opponentId: opponentId);
  }

  void startChat(
      BuildContext context, UserData userData, UserData? expertData) {
    if (_brandManager.getCurrentBrand() is! ZodiacBrand) {
      _brandManager.setCurrentBrand(ZodiacBrand());
    }
    context.popForced();

    if (ZodiacBrand().context?.currentRoutePath ==
        RoutePathsZodiac.chatScreen) {
      ZodiacBrand().context?.replace(
              route: ZodiacChat(
            key: UniqueKey(),
            userData: userData,
            fromStartingChat: true,
          ));
    } else {
      ZodiacBrand().context?.push(
              route: ZodiacChat(
            userData: userData,
            fromStartingChat: true,
          ));
    }

    _webSocketManager.sendCreateRoom(
        clientId: _startCallData.userData?.id,
        expertFee: _startCallData.expertData?.fee);

    ZodiacBrand().analytics.trackEvent(AnalyticsEvent.chatAnswered(
          advisorId: expertData?.id.toString() ?? '',
          orderId: 'orderId',
          buyerId: 'buyerId',
        ));
  }
}
