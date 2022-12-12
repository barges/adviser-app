import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/network/responses/conversations_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final ScrollController historyMessagesScrollController = ScrollController();
  final CachingManager _cachingManager;
  final ChatsRepository _repository;
  final String _clientId;
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final Codec _codec = Codec.aacMP4;
  final int _limit = 25;
  int _offset = 0;
  int? _total;
  FlutterSoundPlayer? _playerMedia;

  HistoryCubit(
    this._cachingManager,
    this._repository,
      this._clientId,
  ) : super(const HistoryState()) {
    _init();
    _getData();
  }

  @override
  Future<void> close() {
    historyMessagesScrollController.dispose();
    _playerMedia?.closePlayer();
    _playerMedia = null;
    return super.close();
  }

  Future<void> _init() async {
    await _initAudioSession();

    const logLevel = Level.nothing;
    _playerMedia = await FlutterSoundPlayer(logLevel: logLevel).openPlayer();

    await _playerMedia?.setSubscriptionDuration(
      const Duration(milliseconds: 100),
    );

    historyMessagesScrollController.addListener(scrollControllerListener);
  }

  Future<void> _getData() async {
    _getConversations();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  void scrollControllerListener() {
    if (!_mainCubit.state.isLoading &&
        historyMessagesScrollController.position.extentAfter <= 300) {
      _getConversations();
    }
  }

  Future<void> _getConversations() async {
    if (_total != null && _offset >= _total!) {
      return;
    }

    ConversationsResponse conversations =
        await _repository.getConversationsHistory(
            expertID: _cachingManager.getUserId() ?? '',
            clientID: _clientId,
            offset: _offset,
            limit: _limit);

    _total = conversations.total;
    _offset = _offset + _limit;

    final messages = List.of(state.historyMessages);
    for (var element in conversations.history ?? []) {
      messages.add(
        element.answer?.copyWith(
          isAnswer: true,
          type: element.question?.type,
          ritualIdentifier: element.question?.ritualIdentifier,
        ),
      );
      messages.add(
        element.question,
      );
    }

    emit(state.copyWith(
      historyMessages: messages,
    ));
  }

  Future<void> startPlayAudio(String audioUrl) async {
    if (state.audioUrl != audioUrl) {
      await _playerMedia?.stopPlayer();

      emit(
        state.copyWith(
          isPlayingAudio: false,
          isPlayingAudioFinished: true,
          audioUrl: audioUrl,
        ),
      );
    }

    if (_playerMedia != null && _playerMedia!.isPaused) {
      await _playerMedia!.resumePlayer();

      emit(
        state.copyWith(
          isPlayingAudio: true,
          isPlayingAudioFinished: false,
        ),
      );
      return;
    }

    await _playerMedia?.startPlayer(
      fromURI: audioUrl,
      codec: _codec,
      sampleRate: 44000,
      whenFinished: () => emit(
        state.copyWith(
          isPlayingAudio: false,
          isPlayingAudioFinished: true,
        ),
      ),
    );

    emit(
      state.copyWith(
        isPlayingAudio: true,
        isPlayingAudioFinished: false,
      ),
    );
  }

  Future<void> pauseAudio() async {
    await _playerMedia?.pausePlayer();

    emit(
      state.copyWith(
        isPlayingAudio: false,
      ),
    );
  }

  Stream<PlaybackDisposition>? get onMediaProgress => _playerMedia?.onProgress;
}
