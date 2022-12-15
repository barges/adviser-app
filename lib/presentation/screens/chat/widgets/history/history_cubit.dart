import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:shared_advisor_interface/data/models/chats/history.dart';
import 'package:shared_advisor_interface/data/network/responses/history_response.dart';
import 'package:shared_advisor_interface/domain/repositories/chats_repository.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/screens/chat/widgets/history/history_state.dart';
import 'package:shared_advisor_interface/presentation/services/connectivity_service.dart';

enum HistoryScrollDirection {
  up,
  down,
}

class HistoryCubit extends Cubit<HistoryState> {
  final ScrollController historyMessagesScrollController = ScrollController();
  final ConnectivityService _connectivityService =
      getIt.get<ConnectivityService>();
  final ChatsRepository _repository;
  final String _clientId;
  final String? storyId;
  FlutterSoundPlayer? _playerMedia;
  final Codec _codec = Codec.aacMP4;

  final List<History> _historyList = [];
  final int limit = 15;
  final GlobalKey scrollItemKey = GlobalKey();
  bool _hasMore = true;
  String? _lastItem;
  bool _hasBefore = false;
  String? _firstItem;
  bool _isLoading = false;
  bool isFirstRequest = true;

  HistoryCubit(
    this._repository,
    this._clientId,
    this._playerMedia,
    this.storyId,
  ) : super(const HistoryState()) {
    _getHistoryList(firstRequest: true);
    historyMessagesScrollController.addListener(scrollControllerListener);
  }

  @override
  Future<void> close() {
    historyMessagesScrollController.dispose();
    _playerMedia?.closePlayer();
    _playerMedia = null;
    return super.close();
  }

  void scrollControllerListener() {
    if (!_isLoading &&
        historyMessagesScrollController.position.extentAfter <= 300) {
      _getHistoryList(
        scrollDirection: HistoryScrollDirection.down,
      );
    }
    if (!_isLoading &&
        historyMessagesScrollController.position.extentBefore <= 0) {
      _getHistoryList(
        scrollDirection: HistoryScrollDirection.up,
      );
    }
  }

  Future<void> _getHistoryList({
    bool firstRequest = false,
    HistoryScrollDirection? scrollDirection,
  }) async {
    _isLoading = true;
    try {
      if (firstRequest && await _connectivityService.checkConnection()) {
        final HistoryResponse result = await _repository.getHistoryList(
          clientId: _clientId,
          limit: limit,
          storyId: storyId,
        );
        _hasMore = result.hasMore ?? false;
        _hasBefore = result.hasBefore ?? false;
        _lastItem = result.lastItem;
        _firstItem = result.firstItem;

        _historyList.addAll(result.history ?? const []);
        logger.d(_historyList);
        emit(state.copyWith(
          historyMessages: List.of(_historyList),
        ));
        await _getHistoryList(scrollDirection: HistoryScrollDirection.up);
      } else {
        if (_hasMore &&
            await _connectivityService.checkConnection() &&
            scrollDirection == HistoryScrollDirection.down) {
          final HistoryResponse result = await _repository.getHistoryList(
            clientId: _clientId,
            limit: limit,
            lastItem: _lastItem,
          );
          _hasMore = result.hasMore ?? false;

          if (_lastItem != result.lastItem) {
            _lastItem = result.lastItem;
            _historyList.insertAll(0, result.history ?? const []);
          }

          emit(state.copyWith(
            historyMessages: List.of(_historyList),
          ));
        } else if (_hasBefore &&
            await _connectivityService.checkConnection() &&
            scrollDirection == HistoryScrollDirection.up) {
          final HistoryResponse result = await _repository.getHistoryList(
            clientId: _clientId,
            limit: limit,
            firstItem: _firstItem,
          );
          _hasBefore = result.hasBefore ?? false;

          if (_firstItem != result.firstItem) {
            _firstItem = result.firstItem;
            _historyList.addAll(result.history ?? const []);
            logger.d(_historyList);
          }

          emit(state.copyWith(
            historyMessages: List.of(_historyList),
          ));

          scrollToItem();
        }
      }
    } on DioError catch (e) {
      logger.d(e);
    }
    _isLoading = false;
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

  void scrollToItem() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = scrollItemKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(context);
      }
    });

    isFirstRequest = false;
  }

  Stream<PlaybackDisposition>? get onMediaProgress => _playerMedia?.onProgress;
}
