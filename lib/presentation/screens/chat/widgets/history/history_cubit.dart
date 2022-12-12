import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:shared_advisor_interface/data/cache/caching_manager.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
import 'package:shared_advisor_interface/data/network/responses/history_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final ScrollController historyMessagesScrollController = ScrollController();
  final CachingManager _cachingManager;
  final ChatsRepository _repository;
  final String _clientId;
  final String? _storyId;
  FlutterSoundPlayer? _playerMedia;
  final MainCubit _mainCubit = getIt.get<MainCubit>();
  final Codec _codec = Codec.aacMP4;

  final List<History> _historyList = [];
  final int _limit = 25;
  bool _hasMore = true;
  String? _lastItem;
  bool _hasBefore = false;
  String? _firstItem;

  HistoryCubit(
    this._cachingManager,
    this._repository,
    this._clientId,
    this._playerMedia,
    this._storyId,
  ) : super(const HistoryState()) {
    _getData();
  }

  @override
  Future<void> close() {
    historyMessagesScrollController.dispose();
    _playerMedia?.closePlayer();
    _playerMedia = null;
    return super.close();
  }

  Future<void> _getData() async {
    _getHistoryList();
  }

  void scrollControllerListener() {
    if (!_mainCubit.state.isLoading &&
        historyMessagesScrollController.position.extentAfter <= 300) {
      _getHistoryList(refresh: true);
    }
  }

  Future<void> _getHistoryList({bool refresh = false}) async {
    try {
      if (refresh) {
        _hasMore = true;
        _lastItem = null;
        _historyList.clear();
      }
      if (_hasMore && _mainCubit.state.internetConnectionIsAvailable) {
        final HistoryResponse result = await _repository.getHistoryList(
          clientId: _clientId,
          limit: _limit,
          lastItem: _lastItem,
          storyId: _storyId,
          firstItem: _firstItem,
        );
        _hasMore = result.hasMore ?? true;
        _lastItem = result.lastItem;
        _hasBefore = result.hasBefore ?? false;
        _firstItem = result.firstItem;

        _historyList.addAll(result.history ?? const []);
        logger.d(_historyList);
        emit(state.copyWith(
          historyMessages: List.of(_historyList),
        ));
      }
    } on DioError catch (e) {
      logger.d(e);
    }
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
